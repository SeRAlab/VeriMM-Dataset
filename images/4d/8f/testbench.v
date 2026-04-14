`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_in1 = 0;
            data_in2 = 0;
            ctrl = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Addition (15 + 25)");
            reset_dut();
            data_in1 = 8'd15;
            data_in2 = 8'd25;
            ctrl = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Addition Overflow (200 + 100)");
            reset_dut();
            data_in1 = 8'd200;
            data_in2 = 8'd100;
            ctrl = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Subtraction (50 - 20)");
            reset_dut();
            data_in1 = 8'd50;
            data_in2 = 8'd20;
            ctrl = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Subtraction Underflow (10 - 20)");
            reset_dut();
            data_in1 = 8'd10;
            data_in2 = 8'd20;
            ctrl = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multiplication (12 * 5)");
            reset_dut();
            data_in1 = 8'd12;
            data_in2 = 8'd5;
            ctrl = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Multiplication Overflow (32 * 10)");
            reset_dut();
            data_in1 = 8'd32;
            data_in2 = 8'd10;
            ctrl = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd64);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Division (100 / 4)");
            reset_dut();
            data_in1 = 8'd100;
            data_in2 = 8'd4;
            ctrl = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Division Truncation (7 / 2)");
            reset_dut();
            data_in1 = 8'd7;
            data_in2 = 8'd2;
            ctrl = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Verify Reset clears output");
            reset_dut();
            data_in1 = 8'd50;
            data_in2 = 8'd50;
            ctrl = 2'b00;
            @(posedge clk);
            #1;

            if (result == 8'd100) begin
                reset = 1;
                @(posedge clk);
                #1;
                #1;

                check_outputs(8'd0);
                reset = 0;
            end else begin
                $display("Initial setup for reset test failed");
                fail_count = fail_count + 1;
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, ctrl, data_in1, data_in2, reset, result);
    end

endmodule
