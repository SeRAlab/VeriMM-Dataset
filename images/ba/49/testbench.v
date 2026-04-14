`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reversal (Control=3, Data=0xAA)", test_num);
            reset_dut();
            control = 4'd3;
            data_in = 8'hAA;

            repeat(2) @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Max Control Value (Control=15, Data=0x01)", test_num);
            reset_dut();
            control = 4'd15;
            data_in = 8'h01;
            repeat(15) @(posedge clk);
            #2;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Data stability before trigger", test_num);
            reset_dut();
            control = 4'd5;
            data_in = 8'hFF;
            @(posedge clk);
            data_in = 8'hC1;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(8'h83);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Min Control Value (Control=1, Data=0xF0)", test_num);
            reset_dut();
            control = 4'd1;
            data_in = 8'hF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Verify data is held after trigger", test_num);
            reset_dut();
            control = 4'd2;
            data_in = 8'hCC;
            repeat(2) @(posedge clk);
            #1 data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, control, data_in, reset, data_out);
    end

endmodule
