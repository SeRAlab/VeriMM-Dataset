`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] B;
    reg [3:0] select;
    wire [15:0] out;
    wire [15:0] shift_left;
    wire [15:0] shift_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .select(select),
        .out(out),
        .shift_left(shift_left),
        .shift_right(shift_right)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Barrel Shifter - Right Shift by 1", test_num);
        A = 16'h8000;
        B = 4'b0001;
        select = 4'b0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h4000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Barrel Shifter - Right Shift by 7", test_num);
        A = 16'hFFFF;
        B = 4'b0111;
        select = 4'b0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h01FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Barrel Shifter - Right Shift by 0", test_num);
        A = 16'h1234;
        B = 4'b0000;
        select = 4'b0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Barrel Shifter - Left Shift by 1", test_num);
        A = 16'h0001;
        B = 4'b1001;
        select = 4'b0000;
        #1;

        check_outputs(16'h0000, 16'h0002, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Barrel Shifter - Left Shift by 4", test_num);
        A = 16'h0F0F;
        B = 4'b1100;
        select = 4'b0000;
        #1;

        check_outputs(16'h0000, 16'hF0F0, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Decoder - B=15 (~B=0)", test_num);
        A = 16'hFFFF;
        B = 4'b1111;
        select = 4'b0001;
        #1;

        check_outputs(16'h0001, 16'h0000, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Decoder - B=0 (~B=15)", test_num);
        A = 16'h0000;
        B = 4'b0000;
        select = 4'b0001;
        #1;

        check_outputs(16'h8000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Decoder - B=10 (~B=5)", test_num);
        A = 16'h1111;
        B = 4'b1010;
        select = 4'b0001;
        #1;

        check_outputs(16'h0020, 16'h0000, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Inactive Select 0010", test_num);
        A = 16'hFFFF;
        B = 4'b1111;
        select = 4'b0010;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Inactive Select 1111", test_num);
        A = 16'hAAAA;
        B = 4'b0101;
        select = 4'b1111;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000);
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
        input [15:0] expected_out;
        input [15:0] expected_shift_left;
        input [15:0] expected_shift_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_shift_left === (expected_shift_left ^ shift_left ^ expected_shift_left) &&
                expected_shift_right === (expected_shift_right ^ shift_right ^ expected_shift_right)) begin
                $display("PASS");
                $display("  Outputs: out=%h, shift_left=%h, shift_right=%h",
                         out, shift_left, shift_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, shift_left=%h, shift_right=%h",
                         expected_out, expected_shift_left, expected_shift_right);
                $display("  Got:      out=%h, shift_left=%h, shift_right=%h",
                         out, shift_left, shift_right);
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
