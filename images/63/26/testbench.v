`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [7:0] pedge_clear;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .pedge_clear(pedge_clear)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            in = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Single bit positive edge (bit 0)");
            in = 8'h01;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Single bit positive edge (bit 7)");
            in = 8'h80;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: All bits positive edge");
            in = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: No transition (stay 0)");
            in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Sustained high (1 -> 1, no edge)");
            in = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Falling edge (1 -> 0)");
            in = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Pattern positive edge (0xAA)");
            in = 8'hAA;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Rapid toggle 0-1-0 (detect edge then clear)");
            in = 8'h01;
            @(posedge clk);
            in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        testcase008();
        
        
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
        input [7:0] expected_pedge_clear;
        begin
            if (expected_pedge_clear === (expected_pedge_clear ^ pedge_clear ^ expected_pedge_clear)) begin
                $display("PASS");
                $display("  Outputs: pedge_clear=%h",
                         pedge_clear);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pedge_clear=%h",
                         expected_pedge_clear);
                $display("  Got:      pedge_clear=%h",
                         pedge_clear);
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
        $dumpvars(0,clk, in, pedge_clear);
    end

endmodule
