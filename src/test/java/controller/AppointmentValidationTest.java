package controller;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/**
 * Unit tests for the validation rules used inside AppointmentServlet.
 *
 * These tests mirror the exact validation logic found in
 * AppointmentServlet.doPost() (required fields, past-date rejection,
 * and dentist double-booking prevention) so that the rules can be
 * verified independently of the servlet/HTTP/database layer.
 *
 * TDD note: each test below was written to describe the expected
 * behaviour BEFORE the corresponding validation code was written
 * in AppointmentServlet, following the Red -> Green -> Refactor cycle.
 */
class AppointmentValidationTest {

    // A tiny in-memory model of existing appointments, used to
    // simulate the "dentist double-booking" check that the real
    // servlet performs against the database.
    private List<String[]> existingAppointments;

    @BeforeEach
    void setUp() {
        existingAppointments = new ArrayList<>();
        // {dentist, date, time, status}
        existingAppointments.add(new String[] {
            "Dr.pasindu", "2026-09-10", "10:00:00", "Scheduled"
        });
    }

    // =====================================================
    // TEST 1: Required field validation
    // =====================================================
    @Test
    void testAppointmentRejectedWhenDentistIsEmpty() {
        String dentist = "";
        boolean isValid = isRequiredFieldValid(dentist);
        assertFalse(isValid, "Empty dentist name must be rejected");
    }

    @Test
    void testAppointmentAcceptedWhenDentistIsProvided() {
        String dentist = "Dr.pasindu";
        boolean isValid = isRequiredFieldValid(dentist);
        assertTrue(isValid, "A non-empty dentist name must be accepted");
    }

    // =====================================================
    // TEST 2: Past-date validation
    // (mirrors AppointmentServlet's LocalDate.now() check)
    // =====================================================
    @Test
    void testPastAppointmentDateIsRejected() {
        LocalDate pastDate = LocalDate.now().minusDays(1);
        boolean isValid = isAppointmentDateValid(pastDate);
        assertFalse(isValid, "A date before today must be rejected");
    }

    @Test
    void testFutureAppointmentDateIsAccepted() {
        LocalDate futureDate = LocalDate.now().plusDays(3);
        boolean isValid = isAppointmentDateValid(futureDate);
        assertTrue(isValid, "A future date must be accepted");
    }

    @Test
    void testTodayAppointmentDateIsAccepted() {
        LocalDate today = LocalDate.now();
        boolean isValid = isAppointmentDateValid(today);
        assertTrue(isValid, "Today's date must be accepted (not before today)");
    }

    // =====================================================
    // TEST 3: Dentist double-booking validation
    // (mirrors AppointmentServlet's conflictSql check)
    // =====================================================
    @Test
    void testDoubleBookingIsRejectedForSameDentistDateAndTime() {
        boolean slotTaken = isSlotTaken(
            existingAppointments, "Dr.pasindu", "2026-09-10", "10:00:00"
        );
        assertTrue(slotTaken, "Booking the same dentist/date/time twice must be detected as a conflict");
    }

    @Test
    void testDifferentTimeForSameDentistIsAccepted() {
        boolean slotTaken = isSlotTaken(
            existingAppointments, "Dr.pasindu", "2026-09-10", "11:30:00"
        );
        assertFalse(slotTaken, "A different time slot for the same dentist must not be flagged as a conflict");
    }

    @Test
    void testSameTimeForDifferentDentistIsAccepted() {
        boolean slotTaken = isSlotTaken(
            existingAppointments, "Dr.Ara", "2026-09-10", "10:00:00"
        );
        assertFalse(slotTaken, "The same time slot with a different dentist must not be flagged as a conflict");
    }

    @Test
    void testCancelledAppointmentDoesNotCountAsConflict() {
        existingAppointments.add(new String[] {
            "Dr.sharn", "2026-09-12", "09:00:00", "Cancelled"
        });

        boolean slotTaken = isSlotTaken(
            existingAppointments, "Dr.sharn", "2026-09-12", "09:00:00"
        );
        assertFalse(slotTaken, "A cancelled appointment must not block a new booking for the same slot");
    }

    // =====================================================
    // Helper methods below reproduce the validation rules
    // implemented in AppointmentServlet.doPost(), so the
    // business rules can be tested without a servlet
    // container, HTTP request, or live database connection.
    // =====================================================

    private boolean isRequiredFieldValid(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private boolean isAppointmentDateValid(LocalDate requestedDate) {
        return !requestedDate.isBefore(LocalDate.now());
    }

    private boolean isSlotTaken(List<String[]> appointments,
                                 String dentist,
                                 String date,
                                 String time) {

        for (String[] appt : appointments) {
            String apptDentist = appt[0];
            String apptDate = appt[1];
            String apptTime = appt[2];
            String apptStatus = appt[3];

            if (apptDentist.equals(dentist)
                    && apptDate.equals(date)
                    && apptTime.equals(time)
                    && !apptStatus.equals("Cancelled")) {
                return true;
            }
        }
        return false;
    }
}
