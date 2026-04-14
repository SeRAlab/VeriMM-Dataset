`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg mode;
    reg rst;
    wire carry_out;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .mode(mode),
        .rst(rst),
        .carry_out(carry_out),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            mode = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            mode = 0; a = 4'h4; b = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h9);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            mode = 0; a = 4'hC; b = 4'h6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            mode = 0; a = 4'hF; b = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            mode = 1; a = 4'hA; b = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            mode = 1; a = 4'h3; b = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            mode = 1; a = 4'h7; b = 4'h7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            mode = 0; a = 4'hF; b = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            mode = 1; a = 4'h0; b = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
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
        input expected_carry_out;
        input [3:0] expected_result;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
        $dumpvars(0,a, b, clk, mode, rst, carry_out, result);
    end

endmodule
