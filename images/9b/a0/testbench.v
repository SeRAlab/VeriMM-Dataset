`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: 0 -> 1");
        reset_dut();
        data_in = 4'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: 5 -> 6");
        reset_dut();
        data_in = 4'd5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: 14 -> 15");
        reset_dut();
        data_in = 4'd14;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: 15 -> 0");
        reset_dut();
        data_in = 4'd15;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: 10 -> 11");
        reset_dut();
        data_in = 4'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: 7 -> 8");
        reset_dut();
        data_in = 4'b0111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
