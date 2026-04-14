`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg carry_in;
    reg mode;
    reg reset;
    wire [3:0] C;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .carry_in(carry_in),
        .mode(mode),
        .reset(reset),
        .C(C),
        .carry_out(carry_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            mode = 0;
            carry_in = 0;
            reset = 1;
            @(posedge CLK);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'hA;
            B = 4'h5;
            reset = 1;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            #1;

            check_outputs(4'h0, 0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd3;
            B = 4'd4;
            mode = 0;
            carry_in = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 0, 3 + 4", test_num);
            #1;

            check_outputs(4'd7, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5;
            B = 4'd2;
            mode = 0;
            carry_in = 1;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 0, 5 + 2 + cin(1)", test_num);
            #1;

            check_outputs(4'd8, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            mode = 0;
            carry_in = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 0, 12 + 5 (Overflow)", test_num);
            #1;

            check_outputs(4'd1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd2;
            B = 4'd3;
            mode = 1;
            carry_in = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 1, 2 + (3 + 1)", test_num);
            #1;

            check_outputs(4'd6, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd10;
            B = 4'd2;
            mode = 1;
            carry_in = 1;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 1, 10 + (2 + 1) + cin(1)", test_num);
            #1;

            check_outputs(4'd14, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0;
            B = 4'd15;
            mode = 1;
            carry_in = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 1, 0 + (15 + 1)", test_num);
            #1;

            check_outputs(4'd0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd14;
            mode = 1;
            carry_in = 0;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 1, 15 + (14 + 1)", test_num);
            #1;

            check_outputs(4'd14, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            mode = 1;
            carry_in = 1;
            @(posedge CLK);
            #1;
            $display("Testcase %0d: Mode 1, 15 + (15 + 1) + 1", test_num);
            #1;

            check_outputs(4'd0, 1);
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
        input [3:0] expected_C;
        input expected_carry_out;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: C=%h, carry_out=%b",
                         C, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, carry_out=%b",
                         expected_C, expected_carry_out);
                $display("  Got:      C=%h, carry_out=%b",
                         C, carry_out);
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
        $dumpvars(0,A, B, CLK, carry_in, mode, reset, C, carry_out);
    end

endmodule
