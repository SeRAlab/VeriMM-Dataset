`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [3:0] data_in;
    reg [2:0] parallel_load;
    reg shift;
    reg [1:0] shift_amount;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .parallel_load(parallel_load),
        .shift(shift),
        .shift_amount(shift_amount),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 0;
            data_in = 0;
            parallel_load = 0;
            shift = 0;
            shift_amount = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 4'b1111;
            shift_amount = 2'b00;
            parallel_load = 3'b101;
            shift = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 4'b1000;
            shift_amount = 2'b01;
            parallel_load = 3'b111;
            shift = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            parallel_load = 3'b011;
            shift = 0;
            @(posedge clk);
            #1;
            shift = 1;
            control = 1;
            data_in = 4'b1111;
            shift_amount = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            parallel_load = 3'b110;
            shift = 0;
            @(posedge clk);
            #1;
            shift = 1;
            control = 0;
            data_in = 4'b1111;
            shift_amount = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            parallel_load = 3'b111;
            shift = 0;
            @(posedge clk);
            #1;
            shift = 1;
            control = 0;
            data_in = 4'b1011;
            shift_amount = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            parallel_load = 3'b100;
            shift = 0;
            data_in = 4'b1100;
            shift_amount = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_out;
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
        $dumpvars(0,clk, control, data_in, parallel_load, shift, shift_amount, out);
    end

endmodule
