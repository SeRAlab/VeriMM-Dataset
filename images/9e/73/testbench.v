`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_val;
    reg rst;
    reg up_down;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .up_down(up_down),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        up_down = 1;
        load_val = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Reset");
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Up Count 5 Cycles");
        reset_dut();
        up_down = 1;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Down Count Roll-under (0 -> 15 -> 14 -> 13)");
        reset_dut();
        up_down = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(4'hD);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Load Value 4'hA");
        reset_dut();
        load_val = 4'hA;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Up Count Rollover (F -> 0)");
        reset_dut();
        load_val = 4'hF;
        load = 1;
        @(posedge clk);
        load = 0;
        up_down = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Load and Down Count");
        reset_dut();
        load_val = 4'h7;
        load = 1;
        @(posedge clk);
        load = 0;
        up_down = 0;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Load Priority over Up Count");
        reset_dut();
        load_val = 4'hC;
        load = 1;
        up_down = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(4'hC);
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
        $dumpvars(0,clk, load, load_val, rst, up_down, out);
    end

endmodule
