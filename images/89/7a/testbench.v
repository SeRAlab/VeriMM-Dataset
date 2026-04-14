`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] current_state;
    reg edge_go;
    reg offset_increase;
    reg resetn;
    reg startn;
    wire [5:0] offset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .current_state(current_state),
        .edge_go(edge_go),
        .offset_increase(offset_increase),
        .resetn(resetn),
        .startn(startn),
        .offset(offset)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            startn = 1;
            current_state = 6'd1;
            edge_go = 0;
            offset_increase = 0;
            @(posedge clk);
            #1 resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Increment");
            reset_dut();
            offset_increase = 1;
            repeat(10) @(posedge clk);
            #1 offset_increase = 0;
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Reset Signal (resetn)");
            reset_dut();
            offset_increase = 1;
            repeat(5) @(posedge clk);
            #1 resetn = 0;
            @(posedge clk);
            #1 resetn = 1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Edge Go Reset");
            reset_dut();
            offset_increase = 1;
            repeat(8) @(posedge clk);
            #1 edge_go = 1;
            @(posedge clk);
            #1 edge_go = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Startn Reset in Initial State");
            reset_dut();
            offset_increase = 1;
            repeat(5) @(posedge clk);
            #1 startn = 0;
            current_state = 6'd0;
            @(posedge clk);
            #1 startn = 1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Startn without Initial State");
            reset_dut();
            offset_increase = 1;
            repeat(5) @(posedge clk);
            #1 startn = 0;
            current_state = 6'd5;
            repeat(2) @(posedge clk);
            #1 startn = 1;
            #1;

            check_outputs(6'd7);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Wrap Around");
            reset_dut();
            offset_increase = 1;
            repeat(64) @(posedge clk);
            #1 offset_increase = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Hold and Increment");
            reset_dut();
            offset_increase = 1;
            repeat(3) @(posedge clk);
            #1 offset_increase = 0;
            repeat(5) @(posedge clk);
            #1 offset_increase = 1;
            repeat(2) @(posedge clk);
            #1 offset_increase = 0;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Priority Check (Reset vs Increment)");
            reset_dut();
            offset_increase = 1;
            repeat(4) @(posedge clk);
            #1 edge_go = 1;

            @(posedge clk);
            #1 edge_go = 0;
            #1;

            check_outputs(6'd0);
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
        input [5:0] expected_offset;
        begin
            if (expected_offset === (expected_offset ^ offset ^ expected_offset)) begin
                $display("PASS");
                $display("  Outputs: offset=%h",
                         offset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: offset=%h",
                         expected_offset);
                $display("  Got:      offset=%h",
                         offset);
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
        $dumpvars(0,clk, current_state, edge_go, offset_increase, resetn, startn, offset);
    end

endmodule
