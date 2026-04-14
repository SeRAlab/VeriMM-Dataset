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
            load = 1;
            data = 100'd0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Load", test_num);
            reset_dut();
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Shift Right 1", test_num);
            reset_dut();
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 100'h7FFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Shift Right 8", test_num);
            reset_dut();
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 100'h00FFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: No Shift (Hold)", test_num);
            reset_dut();
            data = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 100'hAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Consecutive Shifts (R1 then R8)", test_num);
            reset_dut();
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 100'h007FFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Comparison Output Sensitivity", test_num);
            reset_dut();
            data = 100'h5555555555555555555555555;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b00;
            data = 100'h0;
            #1;

            #1;


            check_outputs(1'b1, 100'h5555555555555555555555555);
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
