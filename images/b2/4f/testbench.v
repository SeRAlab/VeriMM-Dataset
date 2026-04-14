`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg [1:0] ena;
    reg load;
    reg reset;
    reg slowena;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ena(ena),
        .load(load),
        .reset(reset),
        .slowena(slowena),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            slowena = 0;
            load = 0;
            ena = 2'b00;
            d = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Initial State Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load and Counter Increment", test_num);
            reset_dut();


            load = 1;
            d = 4'h5;
            @(posedge clk);
            #1 load = 0;


            slowena = 1;
            @(posedge clk);
            @(posedge clk);
            #1 slowena = 0;


            #1;



            check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Operation", test_num);
            reset_dut();


            load = 1;
            d = 4'h1;
            @(posedge clk);
            #1 load = 0;


            ena = 2'b10;
            repeat(4) @(posedge clk);
            #1 ena = 2'b00;


            #1;



            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Operation", test_num);
            reset_dut();


            load = 1;
            d = 4'h8;
            @(posedge clk);
            #1 load = 0;


            ena = 2'b01;
            repeat(2) @(posedge clk);
            #1 ena = 2'b00;


            #1;



            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decade Counter Wrap Around", test_num);
            reset_dut();


            slowena = 1;
            repeat(11) @(posedge clk);
            #1 slowena = 0;


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Combined Shift and Count", test_num);
            reset_dut();


            load = 1;
            d = 4'h3;
            @(posedge clk);
            #1 load = 0;


            slowena = 1;
            ena = 2'b10;
            repeat(2) @(posedge clk);
            #1;
            slowena = 0;
            ena = 2'b00;





            #1;






            check_outputs(8'h0E);
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
        input [7:0] expected_sum;
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
        $dumpvars(0,clk, d, ena, load, reset, slowena, sum);
    end

endmodule
