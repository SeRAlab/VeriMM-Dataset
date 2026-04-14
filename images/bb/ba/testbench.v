`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire out_if_else;
    wire [99:0] q;

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
        .out_if_else(out_if_else),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            ena = 0;
            data = 0;
            shadow_reg = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Loading data with different LSBs...", test_num);
            reset_dut();

            data = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A1;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;

            #1;


            check_outputs(1'b1, 100'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Loading data with same LSBs...", test_num);
            reset_dut();

            data = 100'h55555555555555555555555555555550;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;
            #1;

            check_outputs(1'b0, 100'd0);
        end
        endtask

    task testcase003;

        reg [99:0] next_r;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rotate Right 1...", test_num);
            reset_dut();


            data = 100'h1;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;


            load = 0;
            ena = 2'b00;
            data = 100'h0;
            next_r = rotate_val(shadow_reg, 2'b00);
            @(posedge clk);
            #1;
            shadow_reg = next_r;
            #1;

            check_outputs(1'b0, (100'h0 ^ shadow_reg));
        end
        endtask

    task testcase004;

        reg [99:0] next_r;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rotate Right 8...", test_num);
            reset_dut();

            data = 100'hFF;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;

            load = 0;
            ena = 2'b01;
            data = 100'hFFFF;
            next_r = rotate_val(shadow_reg, 2'b01);
            @(posedge clk);
            #1;
            shadow_reg = next_r;
            #1;

            check_outputs(1'b0, (100'hFFFF ^ shadow_reg));
        end
        endtask

    task testcase005;

        reg [99:0] next_r;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rotate Left 1...", test_num);
            reset_dut();

            data = 100'h8000000000000000000000000;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;

            load = 0;
            ena = 2'b10;
            data = 100'h1;
            next_r = rotate_val(shadow_reg, 2'b10);
            @(posedge clk);
            #1;
            shadow_reg = next_r;
            #1;

            check_outputs(1'b1, (100'h1 ^ shadow_reg));
        end
        endtask

    task testcase006;

        reg [99:0] next_r;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rotate Left 8...", test_num);
            reset_dut();

            data = 100'hFF000000000000000000000000;
            load = 1;
            @(posedge clk);
            #1;
            shadow_reg = data;

            load = 0;
            ena = 2'b11;
            data = 100'h0;
            next_r = rotate_val(shadow_reg, 2'b11);
            @(posedge clk);
            #1;
            shadow_reg = next_r;
            #1;

            check_outputs(1'b0, (100'h0 ^ shadow_reg));
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
        input expected_out_if_else;
        input [99:0] expected_q;
        begin
            if (expected_out_if_else === (expected_out_if_else ^ out_if_else ^ expected_out_if_else) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_if_else=%b, q=%h",
                         out_if_else, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_if_else=%b, q=%h",
                         expected_out_if_else, expected_q);
                $display("  Got:      out_if_else=%b, q=%h",
                         out_if_else, q);
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
        $dumpvars(0,clk, data, ena, load, out_if_else, q);
    end

endmodule
