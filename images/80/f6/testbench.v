`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] OP;
    reg [31:0] OP1;
    wire [31:0] OPS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OP(OP),
        .OP1(OP1),
        .OPS(OPS)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Simple Addition (1 + 1)", test_num);
            OP = 32'd1;
            OP1 = 32'd1;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            OP = 32'd0;
            OP1 = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Adding to Zero", test_num);
            OP = 32'hABCDEF01;
            OP1 = 32'd0;
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Maximum Value and One (Overflow/Wrap)", test_num);
            OP = 32'hFFFFFFFF;
            OP1 = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Two Large Values Wrap Around", test_num);
            OP = 32'hFFFFFFFF;
            OP1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating Bits", test_num);
            OP = 32'h55555555;
            OP1 = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Middle Range Addition", test_num);
            OP = 32'h12345678;
            OP1 = 32'h11111111;
            #1;

            check_outputs(32'h23456789);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Signed-style Positive + Negative (Two's Complement)", test_num);
            OP = 32'd100;
            OP1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'd99);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Carry into MSB", test_num);
            OP = 32'h7FFFFFFF;
            OP1 = 32'h00000001;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Large Hex Addition", test_num);
            OP = 32'h10101010;
            OP1 = 32'h01010101;
            #1;

            check_outputs(32'h11111111);
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
        input [31:0] expected_OPS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OPS === (expected_OPS ^ OPS ^ expected_OPS)) begin
                $display("PASS");
                $display("  Outputs: OPS=%h",
                         OPS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OPS=%h",
                         expected_OPS);
                $display("  Got:      OPS=%h",
                         OPS);
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
