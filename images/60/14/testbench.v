`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg reset;
    wire [3:0] counter_out;
    wire q;
    wire [31:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .data(data),
        .ena(ena),
        .load(load),
        .reset(reset),
        .counter_out(counter_out),
        .q(q),
        .xor_out(xor_out)
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
            ena = 2'b00;
            data = 0;
            d = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 100'hFFFFFFFF_00000000_AAAAAA_555555;
            d = 1'b1;
            load = 1;
            @(posedge clk);
            #2 load = 0;



            #1;




            check_outputs(4'h0, 1'b1, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            load = 1;
            data = 100'h1;
            d = 1'b0;
            @(posedge clk);
            #2 load = 0;
            ena = 2'b01;
            repeat(5) @(posedge clk);
            #2 ena = 2'b00;

            #1;


            check_outputs(4'h5, 1'b0, xor_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ena = 2'b10;
            repeat(3) @(posedge clk);
            #2 ena = 2'b00;

            #1;


            check_outputs(4'hD, 1'b0, xor_out);
        end
        endtask

    task testcase005;

        reg [99:0] pattern;
        begin
            test_num = 5;
            reset_dut();
            pattern = {1'b1, 99'h0};
            data = pattern;
            load = 1;
            d = 1'b0;
            @(posedge clk);
            #2 load = 0;
            ena = 2'b11;
            @(posedge clk);
            @(posedge clk);
            #2 ena = 2'b00;


            if (q !== 1'b0)
                #1;

                check_outputs(counter_out, q, xor_out);
            else
                #1;

                check_outputs(counter_out, 1'b0, xor_out);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 100'h55555555_AAAAAAAA_55555555_0000;
            load = 1;
            @(posedge clk);
            #2 load = 0;

            #1;


            check_outputs(4'h0, 1'b0, xor_out);
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
        input [3:0] expected_counter_out;
        input expected_q;
        input [31:0] expected_xor_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, q=%b, xor_out=%h",
                         counter_out, q, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, q=%b, xor_out=%h",
                         expected_counter_out, expected_q, expected_xor_out);
                $display("  Got:      counter_out=%h, q=%b, xor_out=%h",
                         counter_out, q, xor_out);
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
        $dumpvars(0,clk, d, data, ena, load, reset, counter_out, q, xor_out);
    end

endmodule
