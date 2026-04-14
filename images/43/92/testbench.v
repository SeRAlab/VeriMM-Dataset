`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg ena;
    reg [31:0] in;
    reg load;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ena = 0;
            load = 0;
            in = 0;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            load = 1;
            data = 4'hA;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1; data = 4'h1; @(posedge clk); #1;
            load = 0;

            ena = 1; in = 32'h0; @(posedge clk); #1;
            ena = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            load = 1; data = 4'h1; @(posedge clk); #1;
            load = 0;

            in = 32'h00000001; ena = 1; @(posedge clk); #1;
            ena = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            load = 1; data = 4'h2; @(posedge clk); #1;
            load = 0;

            in = 32'h80000000; ena = 1; @(posedge clk); #1;
            ena = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            in = 32'hFFFFFFFF; @(posedge clk); #1;

            load = 1; data = 4'h1; @(posedge clk); #1;
            load = 0;

            in = 32'h0; ena = 1; @(posedge clk); #1;
            ena = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            load = 1; data = 4'hF;
            ena = 1; in = 32'hFFFFFFFF;
            @(posedge clk); #1;
            load = 0; ena = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            reset = 1; load = 1; data = 4'hF;
            @(posedge clk); #1;
            reset = 0; load = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            ena = 1; in = 0;

            in = 32'h1; @(posedge clk); #1;

            in = 32'h1; @(posedge clk); #1;

            in = 32'h3; @(posedge clk); #1;

            in = 32'h2; @(posedge clk); #1;
            ena = 0;
            #1;

            check_outputs(4'hA);
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
        testcase009();
        
        
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, data, ena, in, load, reset, out);
    end

endmodule
