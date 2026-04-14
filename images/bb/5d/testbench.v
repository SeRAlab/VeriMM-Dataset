`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [2:0] d3;
    reg [3:0] d4;
    reg ena;
    reg load;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .d3(d3),
        .d4(d4),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            ena = 0;
            d3 = 3'b000;
            d4 = 4'b0000;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d4 = 4'b1011;
            load = 1;
            d3 = 3'b000;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(7'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d3 = 3'b111;
            d4 = 4'b0000;
            load = 0;

            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d4 = 4'b1100;
            load = 1;
            @(posedge clk);
            #2;

            load = 0;
            ena = 1;
            d3 = 3'b000;
            @(posedge clk);
            #2;
            ena = 0;
            #1;

            check_outputs(7'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            d4 = 4'b1111;
            load = 1;
            d3 = 3'b111;
            @(posedge clk);
            #2;

            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(7'd16);
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
        input [6:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,areset, clk, d3, d4, ena, load, q);
    end

endmodule
