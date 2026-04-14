`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg rst;
    reg [1:0] shift;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .shift(shift),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 0;
            shift = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data = 4'b0001;
            shift = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data = 4'b1000;
            shift = 2'b01;
            @(posedge clk);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 4'b0010;
            shift = 2'b10;
            @(posedge clk);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data = 4'b0001;
            shift = 2'b00;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data = 4'b1111;
            shift = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data = 4'b0001;
            shift = 2'b00;
            @(posedge clk);
            shift = 2'b11;
            @(posedge clk);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data = 4'b0101;
            shift = 2'b11;
            @(posedge clk);
            #1;

            check_outputs(4'hB);
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
        input [3:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,clk, data, rst, shift, sum);
    end

endmodule
