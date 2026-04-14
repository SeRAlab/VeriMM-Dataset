`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [3:0] counter_out;
    wire [7:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .counter_out(counter_out),
        .max_out(max_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d <= 8'h00;
            reset <= 1;
            @(posedge clk);
            #1;
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            d <= 8'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1, 8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat(8) begin
                d <= 8'd3;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'd8, 8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat(16) begin
                d <= 8'd5;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d <= 8'd255;
            @(posedge clk);
            d <= 8'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd2, 8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(4) begin
                d <= 8'd4;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(4'd4, 8'd4);
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
        input [3:0] expected_counter_out;
        input [7:0] expected_max_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, max_out=%h",
                         counter_out, max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, max_out=%h",
                         expected_counter_out, expected_max_out);
                $display("  Got:      counter_out=%h, max_out=%h",
                         counter_out, max_out);
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
        $dumpvars(0,clk, d, reset, counter_out, max_out);
    end

endmodule
