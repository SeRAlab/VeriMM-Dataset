`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire overflow;
    wire [8:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .overflow(overflow),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            A = 0;
            B = 0;
            @(posedge clk);
            #1 rst = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'd10;
            B = 8'd25;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 9'd35);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'd200;
            B = 8'd55;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 9'd255);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'd255;
            B = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 9'd256);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'd255;
            B = 8'd255;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 9'd510);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'd0;
            B = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 9'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 9'd255);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'd128;
            B = 8'd128;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 9'd256);
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
        input expected_overflow;
        input [8:0] expected_result;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
        $dumpvars(0,A, B, clk, rst, overflow, result);
    end

endmodule
