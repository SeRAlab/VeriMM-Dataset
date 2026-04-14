`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg state;
    reg [2:0] value_input;
    reg [2:0] value_play;
    wire [7:0] ds;
    wire [7:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .state(state),
        .value_input(value_input),
        .value_play(value_play),
        .ds(ds),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            state = 0;
            value_input = 0;
            value_play = 0;
            repeat(2) @(posedge clk);
            #2 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Direct Mode - Value 0", test_num);
            reset_dut();
            state = 0;
            value_input = 3'd0;
            value_play = 3'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfe, 8'hc0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Direct Mode - Value 7", test_num);
            reset_dut();
            state = 0;
            value_input = 3'd7;
            value_play = 3'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfe, 8'hf8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Play Mode - Value 3", test_num);
            reset_dut();
            state = 1;
            value_input = 3'd0;
            value_play = 3'd3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfe, 8'hb0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Play Mode - Value 5", test_num);
            reset_dut();
            state = 1;
            value_input = 3'd2;
            value_play = 3'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfe, 8'h92);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Tube Tracking Check", test_num);
            reset_dut();
            state = 0;
            value_input = 3'd1;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfd, 8'hf9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Play Mode - Value 6", test_num);
            reset_dut();
            state = 1;
            value_play = 3'd6;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfe, 8'h82);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Mode Switch Logic", test_num);
            reset_dut();

            state = 0;
            value_input = 3'd4;
            value_play = 3'd2;
            @(posedge clk);

            state = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hfd, 8'ha4);
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
        input [7:0] expected_ds;
        input [7:0] expected_seg;
        begin
            if (expected_ds === (expected_ds ^ ds ^ expected_ds) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: ds=%h, seg=%h",
                         ds, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ds=%h, seg=%h",
                         expected_ds, expected_seg);
                $display("  Got:      ds=%h, seg=%h",
                         ds, seg);
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
        $dumpvars(0,clk, rst, state, value_input, value_play, ds, seg);
    end

endmodule
