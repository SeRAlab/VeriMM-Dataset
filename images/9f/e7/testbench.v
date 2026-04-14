`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] harvest;
    wire [7:0] storage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .harvest(harvest),
        .storage(storage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            harvest = 2'b00;
            force dut.storage = 8'h00;
            repeat(2) @(posedge clk);
            release dut.storage;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            harvest = 2'b11;

            repeat(10) @(posedge clk);
            $display("Testcase 001: Max Harvest (3)");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            harvest = 2'b10;
            repeat(10) @(posedge clk);
            $display("Testcase 002: Mid Harvest (2)");
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            harvest = 2'b01;
            repeat(10) @(posedge clk);
            $display("Testcase 003: Min Harvest (1)");
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            harvest = 2'b00;
            repeat(10) @(posedge clk);
            $display("Testcase 004: Zero Harvest (0)");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            harvest = 2'b11;
            repeat(5) @(posedge clk);


            harvest = 2'b01;
            repeat(5) @(posedge clk);

            $display("Testcase 005: Storage Retention (Harvest 3 -> 1)");

            #1;


            check_outputs(8'd3);
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
        input [7:0] expected_storage;
        begin
            if (expected_storage === (expected_storage ^ storage ^ expected_storage)) begin
                $display("PASS");
                $display("  Outputs: storage=%h",
                         storage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: storage=%h",
                         expected_storage);
                $display("  Got:      storage=%h",
                         storage);
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
        $dumpvars(0,clk, harvest, storage);
    end

endmodule
