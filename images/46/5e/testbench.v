`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg clk;
    reg reset;
    reg write_signal;
    wire ValidOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .reset(reset),
        .write_signal(write_signal),
        .ValidOut(ValidOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            write_signal = 0;
            address = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Check initial reset state (Address 0)", test_num);
            reset_dut();
            address = 3'd0;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Write to Address 3", test_num);
            reset_dut();
            @(posedge clk);
            address = 3'd3;
            write_signal = 1;
            @(posedge clk);
            write_signal = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Verify unwritten Address 5 is 0", test_num);
            reset_dut();
            @(posedge clk);
            address = 3'd2;
            write_signal = 1;
            @(posedge clk);
            write_signal = 0;
            address = 3'd5;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Multiple writes (Addr 0 and 7)", test_num);
            reset_dut();
            @(posedge clk);
            address = 3'd0; write_signal = 1;
            @(posedge clk);
            address = 3'd7; write_signal = 1;
            @(posedge clk);
            write_signal = 0;
            address = 3'd7;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Write followed by secondary reset", test_num);
            reset_dut();
            @(posedge clk);
            address = 3'd4;
            write_signal = 1;
            @(posedge clk);
            write_signal = 0;
            reset_dut();
            address = 3'd4;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Write to Address 7", test_num);
            reset_dut();
            @(posedge clk);
            address = 3'd7;
            write_signal = 1;
            @(posedge clk);
            write_signal = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_ValidOut;
        begin
            if (expected_ValidOut === (expected_ValidOut ^ ValidOut ^ expected_ValidOut)) begin
                $display("PASS");
                $display("  Outputs: ValidOut=%b",
                         ValidOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ValidOut=%b",
                         expected_ValidOut);
                $display("  Got:      ValidOut=%b",
                         ValidOut);
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
        $dumpvars(0,address, clk, reset, write_signal, ValidOut);
    end

endmodule
