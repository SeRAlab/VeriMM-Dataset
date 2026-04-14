`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data_in;
    reg load_en;
    reg shift_en;
    wire [31:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .load_en(load_en),
        .shift_en(shift_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            data_in = 8'h0;
            load_en = 1'b0;
            shift_en = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift one byte in", test_num);
            reset_dut();

            data_in = 8'hAA;
            shift_en = 1'b1;
            @(posedge clock);
            #1;
            shift_en = 1'b0;


            #1;



            check_outputs(32'h000000AA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill register (4 bytes)", test_num);
            reset_dut();


            data_in = 8'h11; shift_en = 1'b1; @(posedge clock); #1;

            data_in = 8'h22; shift_en = 1'b1; @(posedge clock); #1;

            data_in = 8'h33; shift_en = 1'b1; @(posedge clock); #1;

            data_in = 8'h44; shift_en = 1'b1; @(posedge clock); #1;
            shift_en = 1'b0;


            #1;



            check_outputs(32'h11223344, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Shift when full (FIFO behavior)", test_num);
            reset_dut();


            data_in = 8'h11; shift_en = 1'b1; @(posedge clock); #1;
            data_in = 8'h22; shift_en = 1'b1; @(posedge clock); #1;
            data_in = 8'h33; shift_en = 1'b1; @(posedge clock); #1;
            data_in = 8'h44; shift_en = 1'b1; @(posedge clock); #1;


            data_in = 8'h55; shift_en = 1'b1; @(posedge clock); #1;
            shift_en = 1'b0;


            #1;



            check_outputs(32'h22334455, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify load_en operation", test_num);
            reset_dut();



            data_in = 8'hFF;
            load_en = 1'b1;
            shift_en = 1'b1;
            @(posedge clock); #1;
            load_en = 1'b0;
            shift_en = 1'b0;

            #1;


            check_outputs(32'h000000FF, 1'b0, 1'b0);
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
        input [31:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clock, data_in, load_en, shift_en, data_out, empty, full);
    end

endmodule
