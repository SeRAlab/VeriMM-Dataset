`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [1:0] ena;
    reg load;
    reg [7:0] load_value;
    reg reset;
    wire [7:0] counter_out;
    wire [7:0] final_out;
    wire [7:0] shifter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .counter_out(counter_out),
        .final_out(final_out),
        .shifter_out(shifter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            load_value = 8'h00;
            ena = 2'b00;
            data = 8'h00;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5, 8'd5, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            #2;
            load = 1;
            load_value = 8'hA5;
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5, 8'h00);
            load = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 8'h0F;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 8'h1F, 8'h1E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 8'hF0;
            ena = 2'b10;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02, 8'h7A, 8'h78);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            load = 1;
            load_value = 8'h10;
            #1 load = 0;
            data = 8'h20;
            ena = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h31, 8'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            load = 1;
            load_value = 8'hFF;
            #1 load = 0;
            data = 8'h01;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h02, 8'h02);
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
        input [7:0] expected_counter_out;
        input [7:0] expected_final_out;
        input [7:0] expected_shifter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_shifter_out === (expected_shifter_out ^ shifter_out ^ expected_shifter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, final_out=%h, shifter_out=%h",
                         counter_out, final_out, shifter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, final_out=%h, shifter_out=%h",
                         expected_counter_out, expected_final_out, expected_shifter_out);
                $display("  Got:      counter_out=%h, final_out=%h, shifter_out=%h",
                         counter_out, final_out, shifter_out);
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
        $dumpvars(0,clk, data, ena, load, load_value, reset, counter_out, final_out, shifter_out);
    end

endmodule
