`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLEAR;
    reg CLK;
    reg [1:0] CONTROL;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLEAR(CLEAR),
        .CLK(CLK),
        .CONTROL(CONTROL),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLEAR = 1;
            A = 0;
            B = 0;
            CONTROL = 0;
            @(posedge CLK);
            #1;
            CLEAR = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (10 + 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            CONTROL = 2'b00;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Subtraction (50 - 15)", test_num);
            A = 8'd50;
            B = 8'd15;
            CONTROL = 2'b01;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Multiplication (6 * 7)", test_num);
            A = 8'd6;
            B = 8'd7;
            CONTROL = 2'b10;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Division (80 / 4)", test_num);
            A = 8'd80;
            B = 8'd4;
            CONTROL = 2'b11;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            CONTROL = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow (10 - 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            CONTROL = 2'b01;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd246);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Overflow (16 * 16)", test_num);
            A = 8'd16;
            B = 8'd16;
            CONTROL = 2'b10;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Division Truncation (10 / 3)", test_num);
            A = 8'd10;
            B = 8'd3;
            CONTROL = 2'b11;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Clear Activation Check", test_num);
            A = 8'd255;
            B = 8'd255;
            CONTROL = 2'b00;
            @(posedge CLK);
            #1;
            CLEAR = 1;
            @(posedge CLK);
            #1;
            CLEAR = 0;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, CLEAR, CLK, CONTROL, C);
    end

endmodule
