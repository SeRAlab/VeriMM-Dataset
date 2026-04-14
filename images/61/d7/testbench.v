`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] src1;
    reg [31:0] src2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .src1(src1),
        .src2(src2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            src1 = 32'h00000000;
            src2 = 32'h00000000;
            $display("\nTest Case %0d: Zero Addition", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            src1 = 32'h00000005;
            src2 = 32'h0000000A;
            $display("\nTest Case %0d: Basic Addition (5 + 10)", test_num);
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            src1 = 32'hFFFFFFFF;
            src2 = 32'h00000000;
            $display("\nTest Case %0d: Max Value and Zero", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            src1 = 32'hFFFFFFFF;
            src2 = 32'h00000001;
            $display("\nTest Case %0d: Wrap Around (Max + 1)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            src1 = 32'h12345678;
            src2 = 32'h87654321;
            $display("\nTest Case %0d: Adding Large Values", test_num);
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            src1 = 32'hAAAAAAAA;
            src2 = 32'h55555555;
            $display("\nTest Case %0d: Alternating Bits Sum", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            src1 = 32'h7FFFFFFF;
            src2 = 32'h7FFFFFFF;
            $display("\nTest Case %0d: Half-Max Addition", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            src1 = 32'hFFFFFFFF;
            src2 = 32'hFFFFFFFF;
            $display("\nTest Case %0d: Two's Complement (-1 + -1)", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
