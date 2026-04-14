`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_data;
    reg rst;
    wire [15:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .rst(rst),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            in_data = 16'hFFFF;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Synchronous Reset Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Inverting all zeros");
            reset_dut();
            @(negedge clk);
            in_data = 16'h0000;
            wait_cycles(1);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Inverting all ones");
            reset_dut();
            @(negedge clk);
            in_data = 16'hFFFF;
            wait_cycles(1);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Inverting alternating bit pattern 0xAAAA");
            reset_dut();
            @(negedge clk);
            in_data = 16'hAAAA;
            wait_cycles(1);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Inverting arbitrary value 0x1234");
            reset_dut();
            @(negedge clk);
            in_data = 16'h1234;
            wait_cycles(1);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Reset dominance check");
            reset_dut();
            @(negedge clk);
            rst = 1;
            in_data = 16'h5555;
            wait_cycles(1);
            #1;

            check_outputs(16'h0000);
            rst = 0;
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
        input [15:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, rst, out_data);
    end

endmodule
