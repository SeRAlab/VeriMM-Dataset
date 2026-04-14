`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] coeff_in;
    reg rst;
    reg [15:0] x_in;
    wire [31:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coeff_in(coeff_in),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 0;
            coeff_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Multiplication (10 * 5)");
            reset_dut();
            x_in = 16'sd10;
            coeff_in = 20'sd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'sd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Signed Arithmetic (-10 * 5)");
            reset_dut();
            x_in = -16'sd10;
            coeff_in = 20'sd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-32'sd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Shifting and Summation");
            reset_dut();


            x_in = 16'sd2;
            coeff_in = 20'sd3;
            @(posedge clk);


            #1;
            x_in = 16'sd4;
            coeff_in = 20'sd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'sd26);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multi-tap Sequence");
            reset_dut();


            x_in = 16'sd100; coeff_in = 20'sd2;  @(posedge clk); #1;
            x_in = -16'sd50; coeff_in = 20'sd10; @posedge clk; #1;
            x_in = 16'sd10;  coeff_in = 20'sd20; @posedge clk; #2;



            #1;




            check_outputs(-32'sd100);
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
        input [31:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, coeff_in, rst, x_in, y_out);
    end

endmodule
