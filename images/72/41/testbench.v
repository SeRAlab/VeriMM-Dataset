`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [2:0] sidx;
    reg [3:0] val;
    wire [7:0] digit;
    wire [7:0] segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .sidx(sidx),
        .val(val),
        .digit(digit),
        .segment(segment)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            sidx = 0;
            val = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            enable = 1;
            sidx = 3'd0;
            val = 4'h0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFE, 8'h3F);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            enable = 1;
            sidx = 3'd1;
            val = 4'h1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFD, 8'h06);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            enable = 1;
            sidx = 3'd7;
            val = 4'h8;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h7F, 8'h7F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            enable = 1;
            sidx = 3'd3;
            val = 4'hA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hF7, 8'h77);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            enable = 1;
            sidx = 3'd5;
            val = 4'hF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hDF, 8'h71);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            enable = 1;
            sidx = 3'd2;
            val = 4'h5;
            @(posedge clk);
            #1;

            enable = 0;
            sidx = 3'd4;
            val = 4'hE;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFB, 8'h6D);
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
        input [7:0] expected_digit;
        input [7:0] expected_segment;
        begin
            if (expected_digit === (expected_digit ^ digit ^ expected_digit) &&
                expected_segment === (expected_segment ^ segment ^ expected_segment)) begin
                $display("PASS");
                $display("  Outputs: digit=%h, segment=%h",
                         digit, segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%h, segment=%h",
                         expected_digit, expected_segment);
                $display("  Got:      digit=%h, segment=%h",
                         digit, segment);
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
        $dumpvars(0,clk, enable, sidx, val, digit, segment);
    end

endmodule
