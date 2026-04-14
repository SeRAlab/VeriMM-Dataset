`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] SHIFT;
    reg clk;
    reg [3:0] load_data;
    reg rst_n;
    reg up_down;
    wire [3:0] data_out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SHIFT(SHIFT),
        .clk(clk),
        .load_data(load_data),
        .rst_n(rst_n),
        .up_down(up_down),
        .data_out(data_out),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            up_down = 1;
            load_data = 4'b0000;
            SHIFT = 2'b00;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            load_data = 4'd5;
            reset_dut();
            up_down = 1;
            SHIFT = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            load_data = 4'd14;
            reset_dut();
            up_down = 1;
            SHIFT = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            load_data = 4'd1;
            reset_dut();
            up_down = 0;
            SHIFT = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            load_data = 4'd3;
            reset_dut();
            up_down = 1;
            SHIFT = 2'b01;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            load_data = 4'd11;
            reset_dut();
            up_down = 1;
            SHIFT = 2'b10;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            load_data = 4'd8;
            reset_dut();
            up_down = 0;
            SHIFT = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd7, 1'b0);
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
        input [3:0] expected_data_out;
        input expected_overflow;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, overflow=%b",
                         data_out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, overflow=%b",
                         expected_data_out, expected_overflow);
                $display("  Got:      data_out=%h, overflow=%b",
                         data_out, overflow);
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
        $dumpvars(0,SHIFT, clk, load_data, rst_n, up_down, data_out, overflow);
    end

endmodule
