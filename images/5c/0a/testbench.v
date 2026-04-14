`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg mode;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .mode(mode),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            mode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Simple Addition (A=3, B=4, Mode=1)", test_num);
            A = 4'd3;
            B = 4'd4;
            mode = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Addition with Overflow (A=12, B=6, Mode=1)", test_num);
            A = 4'd12;
            B = 4'd6;
            mode = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Simple Subtraction (A=10, B=3, Mode=0)", test_num);
            A = 4'd10;
            B = 4'd3;
            mode = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Subtraction with Underflow (A=2, B=5, Mode=0)", test_num);
            A = 4'd2;
            B = 4'd5;
            mode = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Addition Max Values (A=15, B=15, Mode=1)", test_num);
            A = 4'd15;
            B = 4'd15;
            mode = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Subtraction Result Zero (A=8, B=8, Mode=0)", test_num);
            A = 4'd8;
            B = 4'd8;
            mode = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Subtraction Boundary (A=0, B=15, Mode=0)", test_num);
            A = 4'd0;
            B = 4'd15;
            mode = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %0d: Check registered output timing", test_num);
            A = 4'd5;
            B = 4'd2;
            mode = 1'b1;
            @(posedge clk);
            #1;

            if(out == 4'd7) begin
                mode = 1'b0;
                @(posedge clk);
                #1;
                #1;

                check_outputs(4'd3);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Initial addition failed in toggle check");
            end
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
        input [3:0] expected_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, clk, mode, out);
    end

endmodule
