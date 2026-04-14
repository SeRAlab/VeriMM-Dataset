`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Basic Addition (Enable=1)", test_num);
            enable = 1;
            in1 = 32'd10;
            in2 = 32'd20;
            #10;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Latch Behavior - Enable Low (Retain previous sum)", test_num);
            enable = 0;
            in1 = 32'd100;
            in2 = 32'd200;
            #10;
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Large Values Addition", test_num);
            enable = 1;
            in1 = 32'h7FFFFFFF;
            in2 = 32'h00000001;
            #10;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Overflow Wrap-around", test_num);
            enable = 1;
            in1 = 32'hFFFFFFFF;
            in2 = 32'h00000001;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Zero Addition", test_num);
            enable = 1;
            in1 = 32'hA5A5A5A5;
            in2 = 32'h00000000;
            #10;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Disable and change inputs", test_num);
            enable = 1;
            in1 = 32'h12345678;
            in2 = 32'h11111111;
            #10;
            enable = 0;
            #5;
            in1 = 32'h0;
            in2 = 32'h0;
            #10;
            #1;

            check_outputs(32'h23456789);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Maximum 32-bit Addition", test_num);
            enable = 1;
            in1 = 32'hFFFFFFFF;
            in2 = 32'hFFFFFFFF;
            #10;
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
