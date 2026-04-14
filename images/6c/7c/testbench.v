`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] counter_out;
    reg [3:0] mux_out;
    reg reset;
    reg select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .counter_out(counter_out),
        .mux_out(mux_out),
        .reset(reset),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'h5;
            mux_out = 4'h3;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'hA;
            mux_out = 4'h5;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'hF;
            mux_out = 4'hF;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'hF;
            mux_out = 4'hF;
            select = 1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'h0;
            mux_out = 4'h0;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clk);
            counter_out = 4'h2;
            mux_out = 4'h2;
            select = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            counter_out = 4'h8;
            mux_out = 4'h1;
            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h09);
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
        $dumpvars(0,clk, counter_out, mux_out, reset, select, out);
    end

endmodule
