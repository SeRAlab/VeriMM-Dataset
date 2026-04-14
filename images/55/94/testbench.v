`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg echo;
    reg rst_n;
    wire [23:0] distance;
    wire trig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .echo(echo),
        .rst_n(rst_n),
        .distance(distance),
        .trig(trig)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            echo = 0;
            #20;
            rst_n = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Standard Distance (50us Echo)", test_num);
            reset_dut();


            @(posedge trig);
            @(negedge trig);


            #1000;


            echo = 1;
            #50000;
            echo = 0;


            #2000;



            #1;




            check_outputs(24'd5000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Long Distance (150us Echo)", test_num);
            reset_dut();

            @(posedge trig);
            @(negedge trig);

            #1000;
            echo = 1;
            #150000;
            echo = 0;

            #2000;
            #1;

            check_outputs(24'd15000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Short Distance (5.8us Echo)", test_num);
            reset_dut();

            @(posedge trig);
            @(negedge trig);

            #500;
            echo = 1;
            #5800;
            echo = 0;

            #2000;
            #1;

            check_outputs(24'd580, 1'b0);
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
        input [23:0] expected_distance;
        input expected_trig;
        begin
            if (expected_distance === (expected_distance ^ distance ^ expected_distance) &&
                expected_trig === (expected_trig ^ trig ^ expected_trig)) begin
                $display("PASS");
                $display("  Outputs: distance=%h, trig=%b",
                         distance, trig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance=%h, trig=%b",
                         expected_distance, expected_trig);
                $display("  Got:      distance=%h, trig=%b",
                         distance, trig);
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
        $dumpvars(0,clk, echo, rst_n, distance, trig);
    end

endmodule
