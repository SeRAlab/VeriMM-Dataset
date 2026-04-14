`timescale 1ns/1ps

module ag6502_phase_shift_tb;

    // Testbench signals (sequential circuit)
    reg baseclk;
    reg phi_0;
    wire phi_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ag6502_phase_shift dut (
        .baseclk(baseclk),
        .phi_0(phi_0),
        .phi_1(phi_1)
    );

    // Clock generation (10ns period)
    initial begin
        baseclk = 0;
        forever #5 baseclk = ~baseclk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ag6502_phase_shift Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_phi_1;
        begin
            if (expected_phi_1 === (expected_phi_1 ^ phi_1 ^ expected_phi_1)) begin
                $display("PASS");
                $display("  Outputs: phi_1=%b",
                         phi_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phi_1=%b",
                         expected_phi_1);
                $display("  Got:      phi_1=%b",
                         phi_1);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,baseclk, phi_0, phi_1);
    end

endmodule
