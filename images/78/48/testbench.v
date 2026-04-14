`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (

    );
    task testcase001;

        begin
            reset_dut();
            a = 0; b = 0; c = 0; d = 8'd0;
            expected_out = 8'd0;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 1; b = 1; c = 1; d = 8'd0;
            expected_out = 8'd3;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 1; b = 0; c = 1; d = 8'd10;
            expected_out = 8'd12;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 1; b = 1; c = 1; d = -8'd10;
            expected_out = -8'd7;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 1; b = 1; c = 1; d = 8'd127;
            expected_out = 8'd127 + 3;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 1; b = 0; c = 0; d = -8'd128;
            expected_out = -8'd127;
            #1;

            check_outputs(expected_out);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 0; b = 1; c = 0; d = 8'd50;
            expected_out = 8'd51;
            #1;

            check_outputs(expected_out);
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
        testcase006();
        testcase007();
        
        
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
