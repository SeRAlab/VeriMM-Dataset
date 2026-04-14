`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg [1:0] ena;
    reg load;
    reg reset;
    wire [7:0] led_col;
    wire [7:0] led_row;

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
        .reset(reset),
        .led_col(led_col),
        .led_row(led_row)
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
            ena = 0;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load and Scanning Check", test_num);
            reset_dut();
            data = 64'h8877665544332211;
            load = 1;
            @(posedge clk);
            #1 load = 0;




            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h08, 8'h44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Circular Shift Right Check", test_num);
            reset_dut();
            data = 64'h0000000000000001;
            load = 1;
            @(posedge clk);
            #1 load = 0; ena = 2'b01;
            @(posedge clk);
            #1 ena = 0;




            repeat(5) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h80, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Circular Shift Left Check", test_num);
            reset_dut();
            data = 64'h8000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0; ena = 2'b10;
            @(posedge clk);
            #1 ena = 0;





            repeat(6) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Circular Shift Left 8-bits Check", test_num);
            reset_dut();
            data = 64'h00000000000000FF;
            load = 1;
            @(posedge clk);
            #1 load = 0; ena = 2'b11;
            @(posedge clk);
            #1 ena = 0;





            repeat(7) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h02, 8'hFF);
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
        input [7:0] expected_led_col;
        input [7:0] expected_led_row;
        begin
            if (expected_led_col === (expected_led_col ^ led_col ^ expected_led_col) &&
                expected_led_row === (expected_led_row ^ led_row ^ expected_led_row)) begin
                $display("PASS");
                $display("  Outputs: led_col=%h, led_row=%h",
                         led_col, led_row);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_col=%h, led_row=%h",
                         expected_led_col, expected_led_row);
                $display("  Got:      led_col=%h, led_row=%h",
                         led_col, led_row);
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
        $dumpvars(0,clk, data, ena, load, reset, led_col, led_row);
    end

endmodule
