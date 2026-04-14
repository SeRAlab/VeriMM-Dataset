`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [7:0] and_output;
    wire [99:0] q;
    wire [7:0] q_reg;

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
        .and_output(and_output),
        .q(q),
        .q_reg(q_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 1;
            data = 100'b0;
            d = 8'b0;
            ena = 2'b00;
            @(posedge clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            data = {92'h0, 8'hFF};
            d = 8'hAA;
            @(posedge clk);
            load = 0;

            #1;


            check_outputs(8'hAA, {92'h0, 8'hFF}, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 100'h1;
            d = 8'hFF;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            repeat(4) @(posedge clk);
            ena = 2'b00;

            #1;


            check_outputs(8'h10, 100'h10, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            data = (100'h1 << 99);
            d = 8'h00;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            repeat(99) @(posedge clk);
            ena = 2'b00;

            #1;


            check_outputs(8'h01, 100'h1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 100'hABCDE;
            d = 8'h55;
            @(posedge clk);
            load = 0;
            ena = 2'b00;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hDE & 8'h55, 100'hABCDE, 8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 100'h1;
            d = 8'h0F;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            load = 1;
            data = 100'hFEED;
            d = 8'hCC;
            @(posedge clk);
            load = 0;
            ena = 2'b00;

            #1;


            check_outputs(8'hED & 8'hCC, 100'hFEED, 8'hCC);
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
        input [7:0] expected_and_output;
        input [99:0] expected_q;
        input [7:0] expected_q_reg;
        begin
            if (expected_and_output === (expected_and_output ^ and_output ^ expected_and_output) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_reg === (expected_q_reg ^ q_reg ^ expected_q_reg)) begin
                $display("PASS");
                $display("  Outputs: and_output=%h, q=%h, q_reg=%h",
                         and_output, q, q_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_output=%h, q=%h, q_reg=%h",
                         expected_and_output, expected_q, expected_q_reg);
                $display("  Got:      and_output=%h, q=%h, q_reg=%h",
                         and_output, q, q_reg);
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
        $dumpvars(0,clk, d, data, ena, load, and_output, q, q_reg);
    end

endmodule
