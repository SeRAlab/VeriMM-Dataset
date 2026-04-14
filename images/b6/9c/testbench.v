`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg conv;
    reg [7:0] dac_in;
    reg rst;
    wire [6:0] dac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .conv(conv),
        .dac_in(dac_in),
        .rst(rst),
        .dac_out(dac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            conv = 0;
            dac_in = 8'h00;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Reset and Zero Input", test_num);
            reset_dut();

            dac_in = 8'h00;
            conv = 1;
            @(negedge clk);
            conv = 0;


            #1;



            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Maximum Input Value", test_num);
            reset_dut();

            dac_in = 8'hFF;
            conv = 1;
            @(negedge clk);
            conv = 0;


            #1;



            check_outputs(7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Mid-Range Value", test_num);
            reset_dut();

            dac_in = 8'h80;
            conv = 1;
            @(negedge clk);
            conv = 0;


            #1;



            check_outputs(7'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: No Conversion Trigger", test_num);
            reset_dut();

            dac_in = 8'hAA;
            conv = 0;
            @(negedge clk);


            #1;



            check_outputs(7'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Sequential Updates", test_num);
            reset_dut();


            dac_in = 8'h40;
            conv = 1;
            @(negedge clk);
            conv = 0;


            dac_in = 8'hFF;
            @(negedge clk);


            dac_in = 8'h10;
            conv = 1;
            @(negedge clk);
            conv = 0;


            #1;



            check_outputs(7'h08);
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
        input [6:0] expected_dac_out;
        begin
            if (expected_dac_out === (expected_dac_out ^ dac_out ^ expected_dac_out)) begin
                $display("PASS");
                $display("  Outputs: dac_out=%h",
                         dac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_out=%h",
                         expected_dac_out);
                $display("  Got:      dac_out=%h",
                         dac_out);
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
        $dumpvars(0,clk, conv, dac_in, rst, dac_out);
    end

endmodule
