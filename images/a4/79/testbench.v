`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    wire [15:0] checksum;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .checksum(checksum),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Data (0x0001)", test_num);
            reset_dut();
            data = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0202, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence Data (0x0001, 0x0002)", test_num);
            reset_dut();
            data = 16'h0001; @(posedge clk);
            data = 16'h0002; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0604, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Modulo Logic (Data 0xFFFF)", test_num);
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F0F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Data Impact", test_num);
            reset_dut();
            data = 16'h0001; @(posedge clk);
            data = 16'h0000; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0402, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Wraps", test_num);
            reset_dut();
            data = 16'hFFFF; @(posedge clk);
            data = 16'hFFF0; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1D0E, 1'b1);
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
        input [15:0] expected_checksum;
        input expected_valid;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, valid=%b",
                         checksum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, valid=%b",
                         expected_checksum, expected_valid);
                $display("  Got:      checksum=%h, valid=%b",
                         checksum, valid);
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
        $dumpvars(0,clk, data, reset, checksum, valid);
    end

endmodule
