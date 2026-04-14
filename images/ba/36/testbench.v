`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] L2_plru_val;
    reg valid_way0_idx;
    reg valid_way1_idx;
    reg valid_way2_idx;
    reg valid_way3_idx;
    wire [1:0] repl_waddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .L2_plru_val(L2_plru_val),
        .valid_way0_idx(valid_way0_idx),
        .valid_way1_idx(valid_way1_idx),
        .valid_way2_idx(valid_way2_idx),
        .valid_way3_idx(valid_way3_idx),
        .repl_waddr(repl_waddr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Way 0 Invalid", test_num);
            valid_way0_idx = 0;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b1111;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Way 1 Invalid", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 0;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0000;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Way 2 Invalid", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 0;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0000;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Way 3 Invalid", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 0;
            L2_plru_val = 4'b0000;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: All Ways Invalid", test_num);
            valid_way0_idx = 0;
            valid_way1_idx = 0;
            valid_way2_idx = 0;
            valid_way3_idx = 0;
            L2_plru_val = 4'b1010;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: All Valid, PLRU selects Way 0", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0000;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: All Valid, PLRU selects Way 1", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0010;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: All Valid, PLRU selects Way 2", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0001;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest Case %0d: All Valid, PLRU selects Way 3", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 1;
            valid_way2_idx = 1;
            valid_way3_idx = 1;
            L2_plru_val = 4'b0101;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest Case %0d: Ways 1 and 3 Invalid", test_num);
            valid_way0_idx = 1;
            valid_way1_idx = 0;
            valid_way2_idx = 1;
            valid_way3_idx = 0;
            L2_plru_val = 4'b0000;
            #1;

            check_outputs(2'd1);
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
        input [1:0] expected_repl_waddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_repl_waddr === (expected_repl_waddr ^ repl_waddr ^ expected_repl_waddr)) begin
                $display("PASS");
                $display("  Outputs: repl_waddr=%h",
                         repl_waddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: repl_waddr=%h",
                         expected_repl_waddr);
                $display("  Got:      repl_waddr=%h",
                         repl_waddr);
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
