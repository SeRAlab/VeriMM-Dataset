`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'd0; b = 16'd0; c = 16'd0; d = 16'd0; x = 32'd0;
            #10;
            $display("Test Case 001: All Zeros");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'd10; b = 16'd5;
            c = 16'd2;  d = 16'd3;
            x = 32'd100;
            #10;
            $display("Test Case 002: Small positive values");
            #1;

            check_outputs(32'd156);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'd100; b = 16'd200;
            c = 16'd0;   d = 16'd500;
            x = 32'hAABB;
            #10;
            $display("Test Case 003: One product zero");
            #1;

            check_outputs(32'h0000F8DB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFFFF; b = 16'hFFFF;
            c = 16'd0;    d = 16'd0;
            x = 32'd0;
            #10;
            $display("Test Case 004: Max 16-bit product");
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'd1; b = 16'd1;
            c = 16'd1; d = 16'd1;
            x = 32'hFFFFFFFE;
            #10;
            $display("Test Case 005: 32-bit Overflow via x");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'hFFFF; b = 16'hFFFF;
            c = 16'hFFFF; d = 16'hFFFF;
            x = 32'h00000000;
            #10;
            $display("Test Case 006: Sum of two max products");
            #1;

            check_outputs(32'hFFFC0002);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'hFFFF; b = 16'hFFFF;
            c = 16'hFFFF; d = 16'hFFFF;
            x = 32'hFFFFFFFF;
            #10;
            $display("Test Case 007: Maximum values overflow");
            #1;

            check_outputs(32'hFFFC0001);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
