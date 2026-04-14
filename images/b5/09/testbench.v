`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg M;
    reg [4:0] clk_sel;
    reg clk_src;
    reg reset;
    wire [3:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .clk_sel(clk_sel),
        .clk_src(clk_src),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk_src = 0;
        forever #5 clk_src = ~clk_src;
    end

        task reset_dut;

        begin
            reset = 1;
            M = 0;
            clk_sel = 5'b00000;
            @(posedge clk_src);
            #1 reset = 0;
            $display("DUT Reset performed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Mode M=0 (Right Shift/Pattern 1)", test_num);
            reset_dut();
            M = 0;
            clk_sel = 5'b00001;
            @(posedge clk_src);
            #1;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %03d: Mode M=0, 4 cycles", test_num);
            reset_dut();
            M = 0;
            clk_sel = 5'b00001;
            repeat(4) @(posedge clk_src);
            #1;

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Mode M=1 (Left Shift/Pattern 1)", test_num);
            reset_dut();
            M = 1;
            clk_sel = 5'b00001;
            @(posedge clk_src);
            #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Mode M=1, 4 cycles", test_num);
            reset_dut();
            M = 1;
            clk_sel = 5'b00001;
            repeat(4) @(posedge clk_src);
            #1;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Testing Clock Selection (clk_sel change)", test_num);
            reset_dut();
            clk_sel = 5'b11111;
            M = 0;
            repeat(2) @(posedge clk_src);
            #1;

            #1;


            check_outputs(4'h2);
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
        input [3:0] expected_state;
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
        $dumpvars(0,M, clk_sel, clk_src, reset, state);
    end

endmodule
