`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg enable_crc;
    reg reset;
    reg sync_reset_crc;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .enable_crc(enable_crc),
        .reset(reset),
        .sync_reset_crc(sync_reset_crc),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sync_reset_crc = 0;
            enable_crc = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
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
            @(posedge clk);
            data = 1;
            enable_crc = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            enable_crc = 1;
            data = 1;
            @(posedge clk);
            data = 0;
            @(posedge clk);

            sync_reset_crc = 1;
            @(posedge clk);
            #1 sync_reset_crc = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable_crc = 1;
            data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1D);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable_crc = 1;

            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'h69);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable_crc = 1;
            data = 1;
            @(posedge clk);

            enable_crc = 0;
            data = 1;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h1D);
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
        input [7:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data, enable_crc, reset, sync_reset_crc, crc_out);
    end

endmodule
