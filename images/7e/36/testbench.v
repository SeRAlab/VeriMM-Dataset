`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rstn;
    wire [7:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rstn(rstn),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            enable = 0;
            @(posedge clk);
            #1 rstn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check");
            reset_dut();
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single shift");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Three shifts");
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable signal low test");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full rotation to bit 7");
            reset_dut();
            enable = 1;
            repeat(7) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Wrap around check");
            reset_dut();
            enable = 1;
            repeat(8) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Intermittent enable toggle");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Reset mid-operation");
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            rstn = 0;
            @(posedge clk);
            rstn = 1;
            @(posedge clk);
            #1;

            check_outputs(8'h01);
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
        input [7:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, enable, rstn, state);
    end

endmodule
