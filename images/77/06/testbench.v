`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    wire decimal;
    wire [3:0] enable;
    wire [6:0] segs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .decimal(decimal),
        .enable(enable),
        .segs(segs)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            data0 = 4'h0;
            data1 = 4'h0;
            data2 = 4'h0;
            data3 = 4'h0;
            @(posedge clock);
            #1;
            clear = 0;
            repeat(5) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data0 = 4'h0;

            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h3f);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data0 = 4'hA;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h77);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data0 = 4'hF;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h71);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data0 = 4'h5;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h6d);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            data0 = 4'h8;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h7f);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            data0 = 4'h3;
            repeat(5) @(posedge clock);
            data0 = 4'hC;
            repeat(5) @(posedge clock);

            #1;


            check_outputs(1'b1, 4'b1110, 7'h39);
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
        input expected_decimal;
        input [3:0] expected_enable;
        input [6:0] expected_segs;
        begin
            if (expected_decimal === (expected_decimal ^ decimal ^ expected_decimal) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_segs === (expected_segs ^ segs ^ expected_segs)) begin
                $display("PASS");
                $display("  Outputs: decimal=%b, enable=%h, segs=%h",
                         decimal, enable, segs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal=%b, enable=%h, segs=%h",
                         expected_decimal, expected_enable, expected_segs);
                $display("  Got:      decimal=%b, enable=%h, segs=%h",
                         decimal, enable, segs);
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
        $dumpvars(0,clear, clock, data0, data1, data2, data3, decimal, enable, segs);
    end

endmodule
