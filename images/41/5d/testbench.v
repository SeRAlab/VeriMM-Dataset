`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg [7:0] in;
    reg load;
    wire [7:0] out;

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
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data = 100'b0;
            ena = 2'b00;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[99] = 1'b1;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(8'd99 ^ 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[0] = 1'b1;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'd0 ^ 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[50] = 1'b1;
            data[20] = 1'b1;
            data[80] = 1'b1;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'd80 ^ 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[98] = 1'b1;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;
            #1;

            check_outputs(8'd99 ^ 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[1] = 1'b1;
            in = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;
            #1;

            check_outputs(8'd0 ^ 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[64] = 1'b1;
            in = 8'hAA;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(8'd64 ^ 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            load = 1;
            data = 100'b0;
            data[10] = 1'b1;
            in = 8'hFF;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            repeat(5) @(posedge clk);
            #1;
            ena = 2'b00;
            #1;

            check_outputs(8'd15 ^ 8'hFF);
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, data, ena, in, load, out);
    end

endmodule
