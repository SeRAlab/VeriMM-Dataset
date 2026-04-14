`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg enable;
    reg [3:0] load;
    reg [26:0] load_in;
    wire [4:0] bits;
    wire [26:0] load_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_in(load_in),
        .bits(bits),
        .load_out(load_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            enable = 0;
            load = 4'b0000;
            load_in = 27'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ce = 1;
            load = 4'b0001;
            load_in = 27'h5AA5AA5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00, 27'h5AA5AA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ce = 0;
            load = 4'b0001;
            load_in = 27'h7FFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h00, 27'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            ce = 1;
            load = 4'b0010;
            load_in = 27'h1234567;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 27'h1234567);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            ce = 1;
            load = 4'b1111;
            load_in = 27'h7FFFFFF;
            @(posedge clk);
            #1;

            load = 4'b0000;
            enable = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h1F, 27'h7FFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ce = 1;
            enable = 1;
            load = 4'b1000;
            load_in = 27'h0F0F0F0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 27'h0F0F0F0);
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
        input [4:0] expected_bits;
        input [26:0] expected_load_out;
        begin
            if (expected_bits === (expected_bits ^ bits ^ expected_bits) &&
                expected_load_out === (expected_load_out ^ load_out ^ expected_load_out)) begin
                $display("PASS");
                $display("  Outputs: bits=%h, load_out=%h",
                         bits, load_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bits=%h, load_out=%h",
                         expected_bits, expected_load_out);
                $display("  Got:      bits=%h, load_out=%h",
                         bits, load_out);
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
        $dumpvars(0,ce, clk, enable, load, load_in, bits, load_out);
    end

endmodule
