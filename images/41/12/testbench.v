`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg send;
    wire txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .send(send),
        .txd(txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send = 0;
            data = 8'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 8'h00;
            send = 1;
            @(posedge clk); #1;
            send = 0;
            @(posedge clk); #1;
            $display("Testcase 001: Checking Start Bit (High)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 8'h01;
            send = 1;
            @(posedge clk); #1 send = 0;
            @(posedge clk);
            @(posedge clk); #1;
            $display("Testcase 002: Checking Data Bit 0 (Expected 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 8'hFE;
            send = 1;
            @(posedge clk); #1 send = 0;
            @(posedge clk);
            @(posedge clk); #1;
            $display("Testcase 003: Checking Data Bit 0 (Expected 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 8'h80;
            send = 1;
            @(posedge clk); #1 send = 0;
            repeat(9) @(posedge clk);
            #1;
            $display("Testcase 004: Checking Data Bit 7 (Expected 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 8'h7F;
            send = 1;
            @(posedge clk); #1 send = 0;
            repeat(9) @(posedge clk);
            #1;
            $display("Testcase 005: Checking Data Bit 7 (Expected 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 8'hFF;
            send = 1;
            @(posedge clk); #1 send = 0;
            repeat(10) @(posedge clk);
            #1;
            $display("Testcase 006: Checking Stop Bit (Low)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 8'hFF;
            send = 1;
            @(posedge clk); #1 send = 0;
            @(posedge clk);
            rst = 1;
            @(posedge clk); #1;
            $display("Testcase 007: Checking Reset impact on txd (Expected 0)");
            #1;

            check_outputs(1'b0);
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
        input expected_txd;
        begin
            if (expected_txd === (expected_txd ^ txd ^ expected_txd)) begin
                $display("PASS");
                $display("  Outputs: txd=%b",
                         txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: txd=%b",
                         expected_txd);
                $display("  Got:      txd=%b",
                         txd);
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
        $dumpvars(0,clk, data, rst, send, txd);
    end

endmodule
