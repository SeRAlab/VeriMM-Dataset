`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] and_input;
    reg clk;
    reg load;
    reg [2:0] load_data;
    reg reset;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .and_input(and_input),
        .clk(clk),
        .load(load),
        .load_data(load_data),
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
        load = 0;
        load_data = 3'b000;
        and_input = 2'b00;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Load LSB=1, and_input=11");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b101;
        and_input = 2'b11;
        @(posedge clk);
        load = 0;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Shift operation (LSB should become 0)");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b101;
        and_input = 2'b11;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: AND input masking (and_input=10)");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b001;
        and_input = 2'b10;
        @(posedge clk);
        load = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: AND input masking (and_input=01)");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b001;
        and_input = 2'b01;
        @(posedge clk);
        load = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Load 3'b000");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b000;
        and_input = 2'b11;
        @(posedge clk);
        load = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Asynchronous reset mid-operation");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b111;
        and_input = 2'b11;
        @(posedge clk);
        load = 0;
        #2;
        reset = 1;
        #1;
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Multiple shifts (111 -> 110 -> 100 -> 000)");
        reset_dut();
        @(posedge clk);
        load = 1;
        load_data = 3'b111;
        and_input = 2'b11;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,and_input, clk, load, load_data, reset, out);
    end

endmodule
