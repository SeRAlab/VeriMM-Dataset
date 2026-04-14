`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] ptch_D_diff_sat;
    reg [9:0] ptch_err_I;
    reg [9:0] ptch_err_sat;
    wire [11:0] mtr_duty;
    wire rev;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ptch_D_diff_sat(ptch_D_diff_sat),
        .ptch_err_I(ptch_err_I),
        .ptch_err_sat(ptch_err_sat),
        .mtr_duty(mtr_duty),
        .rev(rev)
    );
    task testcase001;

        begin
            test_num = 1;
            ptch_D_diff_sat = 7'sd0;
            ptch_err_I = 10'sd0;
            ptch_err_sat = 10'sd0;

            #10;
            #1;

            check_outputs(12'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ptch_D_diff_sat = 7'sd0;
            ptch_err_I = 10'sd0;
            ptch_err_sat = 10'sd100;
            #10;

            #1;


            check_outputs(12'h190, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ptch_D_diff_sat = 7'sd0;
            ptch_err_I = 10'sd0;
            ptch_err_sat = -10'sd100;
            #10;

            #1;


            check_outputs(12'h190, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ptch_D_diff_sat = 7'sd0;
            ptch_err_I = 10'sd200;
            ptch_err_sat = 10'sd0;
            #10;
            #1;

            check_outputs(12'h032, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ptch_D_diff_sat = 7'sd30;
            ptch_err_I = 10'sd0;
            ptch_err_sat = 10'sd0;
            #10;
            #1;

            check_outputs(12'h078, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ptch_D_diff_sat = 7'sd10;
            ptch_err_I = 10'sd40;
            ptch_err_sat = 10'sd50;
            #10;

            #1;


            check_outputs(12'h0D2, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ptch_D_diff_sat = 7'sd63;
            ptch_err_I = 10'sd511;
            ptch_err_sat = 10'sd511;
            #10;

            #1;


            check_outputs(12'hFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ptch_D_diff_sat = -7'sd64;
            ptch_err_I = -10'sd512;
            ptch_err_sat = -10'sd512;
            #10;

            #1;


            check_outputs(12'hFFF, 1'b1);
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
        testcase008();
        
        
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
        input [11:0] expected_mtr_duty;
        input expected_rev;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mtr_duty === (expected_mtr_duty ^ mtr_duty ^ expected_mtr_duty) &&
                expected_rev === (expected_rev ^ rev ^ expected_rev)) begin
                $display("PASS");
                $display("  Outputs: mtr_duty=%h, rev=%b",
                         mtr_duty, rev);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mtr_duty=%h, rev=%b",
                         expected_mtr_duty, expected_rev);
                $display("  Got:      mtr_duty=%h, rev=%b",
                         mtr_duty, rev);
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
