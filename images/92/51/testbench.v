`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] qp_i;
    wire [6:0] beta_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .qp_i(qp_i),
        .beta_o(beta_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: QP=0 (Minimum index)", test_num);
            qp_i = 6'd0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: QP=18 (Boundary for zero output)", test_num);
            qp_i = 6'd18;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: QP=19 (First non-zero output)", test_num);
            qp_i = 6'd19;
            #1;

            check_outputs(7'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: QP=25 (Standard mid-range)", test_num);
            qp_i = 6'd25;
            #1;

            check_outputs(7'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: QP=32 (Power of 2 check)", test_num);
            qp_i = 6'd32;
            #1;

            check_outputs(7'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: QP=40 (Upper range index)", test_num);
            qp_i = 6'd40;
            #1;

            check_outputs(7'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: QP=45 (Step jump calculation)", test_num);
            qp_i = 6'd45;
            #1;

            check_outputs(7'd44);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: QP=51 (H.264 Standard Maximum)", test_num);
            qp_i = 6'd51;
            #1;

            check_outputs(7'd68);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: QP=55 (HEVC Extended Range)", test_num);
            qp_i = 6'd55;
            #1;

            check_outputs(7'd88);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: QP=59 (High bit-depth index)", test_num);
            qp_i = 6'd59;
            #1;

            check_outputs(7'd120);
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
        testcase009();
        testcase010();
        
        
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
        input [6:0] expected_beta_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_beta_o === (expected_beta_o ^ beta_o ^ expected_beta_o)) begin
                $display("PASS");
                $display("  Outputs: beta_o=%h",
                         beta_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: beta_o=%h",
                         expected_beta_o);
                $display("  Got:      beta_o=%h",
                         beta_o);
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
