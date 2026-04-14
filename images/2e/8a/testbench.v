`timescale 1ns/1ps

module power_gating_control_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] mode;
    wire gate_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating_control dut (
        .mode(mode),
        .gate_control(gate_control)
    );
    task testcase001;

    begin
        test_num = 1;
        mode = 2'b00;
        $display("Test Case 001: Mode OFF (00)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        mode = 2'b01;
        $display("Test Case 002: Mode IDLE (01)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        mode = 2'b10;
        $display("Test Case 003: Mode ACTIVE (10)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        mode = 2'b11;
        $display("Test Case 004: Mode TEST (11)");
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_gate_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gate_control === (expected_gate_control ^ gate_control ^ expected_gate_control)) begin
                $display("PASS");
                $display("  Outputs: gate_control=%b",
                         gate_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gate_control=%b",
                         expected_gate_control);
                $display("  Got:      gate_control=%b",
                         gate_control);
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

endmodule
