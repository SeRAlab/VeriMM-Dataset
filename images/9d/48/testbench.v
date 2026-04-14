`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adder_out;
    reg clk;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg reset;
    reg [7:0] sub_out;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adder_out(adder_out),
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .reset(reset),
        .sub_out(sub_out),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            multiplier = 0;
            multiplicand = 0;
            adder_out = 0;
            sub_out = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            multiplier = 8'sd2;
            multiplicand = 8'sd3;
            adder_out = 8'sd10;
            sub_out = 8'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            multiplier = -8'sd4;
            multiplicand = 8'sd5;
            adder_out = 8'sd0;
            sub_out = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            multiplier = 8'sd6;
            multiplicand = -8'sd7;
            adder_out = 8'sd20;
            sub_out = 8'sd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd32);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            multiplier = -8'sd10;
            multiplicand = -8'sd5;
            adder_out = 8'sd5;
            sub_out = 8'sd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd40);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            multiplier = 8'sd0;
            multiplicand = 8'sd127;
            adder_out = 8'sd0;
            sub_out = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            multiplier = 8'sd127;
            multiplicand = 8'sd127;
            adder_out = 8'sd127;
            sub_out = 8'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd16256);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            multiplier = -8'sd128;
            multiplicand = 8'sd2;
            adder_out = 8'sd0;
            sub_out = -8'sd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd128);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            multiplier = 8'sd10;
            multiplicand = 8'sd10;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,adder_out, clk, multiplicand, multiplier, reset, sub_out, product);
    end

endmodule
