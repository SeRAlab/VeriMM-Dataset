`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    reg dp;
    wire [7:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .dp(dp),
        .seg(seg)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=0, DP=0", test_num);
            bcd = 4'h0;
            dp = 0;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=1, DP=0", test_num);
            bcd = 4'h1;
            dp = 0;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=2, DP=1", test_num);
            bcd = 4'h2;
            dp = 1;
            #1;

            check_outputs(8'hDB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=3, DP=0", test_num);
            bcd = 4'h3;
            dp = 0;
            #1;

            check_outputs(8'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=4, DP=1", test_num);
            bcd = 4'h4;
            dp = 1;
            #1;

            check_outputs(8'hE6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=5, DP=0", test_num);
            bcd = 4'h5;
            dp = 0;
            #1;

            check_outputs(8'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=6, DP=1", test_num);
            bcd = 4'h6;
            dp = 1;
            #1;

            check_outputs(8'hFD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=7, DP=0", test_num);
            bcd = 4'h7;
            dp = 0;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=8, DP=1", test_num);
            bcd = 4'h8;
            dp = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: BCD=9, DP=0", test_num);
            bcd = 4'h9;
            dp = 0;
            #1;

            check_outputs(8'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid BCD (A), DP=0", test_num);
            bcd = 4'hA;
            dp = 0;
            #1;

            check_outputs(8'h00);
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
        testcase011();
        
        
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
        input [7:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
