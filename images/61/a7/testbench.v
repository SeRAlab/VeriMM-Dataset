`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    reg rst;
    wire [2:0] throw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .rst(rst),
        .throw(throw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            button = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task press_button;

        begin
            button = 1;
            @(posedge clk);
            #1;
            button = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Check reset state (should be 1)");
            reset_dut();
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single button press (1 -> 2)");
            reset_dut();
            press_button();
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Press 4 times (1 -> 5)");
            reset_dut();
            for (i = 0; i < 4; i = i + 1) press_button();
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Press 5 times (1 -> 6)");
            reset_dut();
            for (i = 0; i < 5; i = i + 1) press_button();
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Rollover press (6 -> 1)");
            reset_dut();
            for (i = 0; i < 6; i = i + 1) press_button();
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Rollover and increment (7 presses)");
            reset_dut();
            for (i = 0; i < 7; i = i + 1) press_button();
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Running testcase007: Two full cycles (12 presses -> 1)");
            reset_dut();
            for (i = 0; i < 12; i = i + 1) press_button();
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_throw;
        begin
            if (expected_throw === (expected_throw ^ throw ^ expected_throw)) begin
                $display("PASS");
                $display("  Outputs: throw=%h",
                         throw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: throw=%h",
                         expected_throw);
                $display("  Got:      throw=%h",
                         throw);
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
        $dumpvars(0,button, clk, rst, throw);
    end

endmodule
