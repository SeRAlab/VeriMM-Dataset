`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out1(out1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplication (0 * 0)", test_num);
        in1 = 32'h00000000;
        in2 = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiply by Zero (0x12345678 * 0)", test_num);
        in1 = 32'h12345678;
        in2 = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Property (0xABCDE * 1)", test_num);
        in1 = 32'h000ABCDE;
        in2 = 32'h00000001;
        #1;

        check_outputs(32'h000ABCDE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Unsigned Values (15 * 10)", test_num);
        in1 = 32'd15;
        in2 = 32'd10;
        #1;

        check_outputs(32'd150);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of 2 (2^10 * 2^10)", test_num);
        in1 = 32'h00000400;
        in2 = 32'h00000400;
        #1;

        check_outputs(32'h00100000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Result without Truncation (0xFFFF * 0xFFFF)", test_num);
        in1 = 32'h0000FFFF;
        in2 = 32'h0000FFFF;

        #1;


        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Truncation (0xFFFFFFFF * 2)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'h00000002;

        #1;


        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Values Truncation (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;

        #1;


        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary Values (0x1234 * 0x5678)", test_num);
        in1 = 32'h00001234;
        in2 = 32'h00005678;
        #1;

        check_outputs(32'h06260060);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Partial Truncation (0x10000001 * 0x10000001)", test_num);
        in1 = 32'h10000001;
        in2 = 32'h10000001;

        #1;


        check_outputs(32'h20000001);
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
        input [31:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%h",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h",
                         expected_out1);
                $display("  Got:      out1=%h",
                         out1);
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
