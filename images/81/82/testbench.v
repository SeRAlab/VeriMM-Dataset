`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg tdo;
    wire reset;
    wire shift;
    wire tck;
    wire tdi;
    wire update;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .tdo(tdo),
        .reset(reset),
        .shift(shift),
        .tck(tck),
        .tdi(tdi),
        .update(update)
    );
    task reset_tap;

        begin
            tdo = 0;
            #100;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on State (TDO=0)", test_num);
            reset_tap();


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Drive TDO High", test_num);
            reset_tap();
            tdo = 1;
            #50;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Drive TDO Low", test_num);
            reset_tap();
            tdo = 0;
            #50;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signal Stability over time", test_num);
            reset_tap();
            tdo = 1;
            #200;
            tdo = 0;
            #200;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_reset;
        input expected_shift;
        input expected_tck;
        input expected_tdi;
        input expected_update;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reset === (expected_reset ^ reset ^ expected_reset) &&
                expected_shift === (expected_shift ^ shift ^ expected_shift) &&
                expected_tck === (expected_tck ^ tck ^ expected_tck) &&
                expected_tdi === (expected_tdi ^ tdi ^ expected_tdi) &&
                expected_update === (expected_update ^ update ^ expected_update)) begin
                $display("PASS");
                $display("  Outputs: reset=%b, shift=%b, tck=%b, tdi=%b, update=%b",
                         reset, shift, tck, tdi, update);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset=%b, shift=%b, tck=%b, tdi=%b, update=%b",
                         expected_reset, expected_shift, expected_tck, expected_tdi, expected_update);
                $display("  Got:      reset=%b, shift=%b, tck=%b, tdi=%b, update=%b",
                         reset, shift, tck, tdi, update);
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
