`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ring;
    reg vibrate_mode;
    wire motor;
    wire ringer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ring(ring),
        .vibrate_mode(vibrate_mode),
        .motor(motor),
        .ringer(ringer)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Idle State (ring=0, vibrate_mode=0)", test_num);
        ring = 0;
        vibrate_mode = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Silent Mode State (ring=0, vibrate_mode=1)", test_num);
        ring = 0;
        vibrate_mode = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ringing Active (ring=1, vibrate_mode=0)", test_num);
        ring = 1;
        vibrate_mode = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Motor Active (ring=1, vibrate_mode=1)", test_num);
        ring = 1;
        vibrate_mode = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition Check - Back to Idle", test_num);
        ring = 0;
        vibrate_mode = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_motor;
        input expected_ringer;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_motor === (expected_motor ^ motor ^ expected_motor) &&
                expected_ringer === (expected_ringer ^ ringer ^ expected_ringer)) begin
                $display("PASS");
                $display("  Outputs: motor=%b, ringer=%b",
                         motor, ringer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: motor=%b, ringer=%b",
                         expected_motor, expected_ringer);
                $display("  Got:      motor=%b, ringer=%b",
                         motor, ringer);
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
