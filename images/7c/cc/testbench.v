`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    wire [31:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd100;
        b = 32'd50;
        op = 2'b00;
        $display("Testcase %0d: Addition (100 + 50)", test_num);
        #1;

        check_outputs(32'd150);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'hFFFFFFFF;
        b = 32'd1;
        op = 2'b00;
        $display("Testcase %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'd500;
        b = 32'd200;
        op = 2'b01;
        $display("Testcase %0d: Subtraction (500 - 200)", test_num);
        #1;

        check_outputs(32'd300);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'd10;
        b = 32'd20;
        op = 2'b01;
        $display("Testcase %0d: Subtraction Underflow (10 - 20)", test_num);
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'd12;
        b = 32'd12;
        op = 2'b10;
        $display("Testcase %0d: Multiplication (12 * 12)", test_num);
        #1;

        check_outputs(32'd144);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'h00010000;
        b = 32'h00010000;
        op = 2'b10;
        $display("Testcase %0d: Multiplication Overflow (0x10000 * 0x10000)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'd1000;
        b = 32'd10;
        op = 2'b11;
        $display("Testcase %0d: Division (1000 / 10)", test_num);
        #1;

        check_outputs(32'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'd7;
        b = 32'd2;
        op = 2'b11;
        $display("Testcase %0d: Division Floor (7 / 2)", test_num);
        #1;

        check_outputs(32'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'd0;
        b = 32'd500;
        op = 2'b00;
        $display("Testcase %0d: Addition with Zero (0 + 500)", test_num);
        #1;

        check_outputs(32'd500);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'h12345678;
        b = 32'h12345678;
        op = 2'b01;
        $display("Testcase %0d: Subtraction to Zero", test_num);
        #1;

        check_outputs(32'd0);
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
        input [31:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
