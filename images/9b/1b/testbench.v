`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] p0;
    reg [7:0] p1;
    reg [7:0] p2;
    reg [7:0] p3;
    reg [7:0] p4;
    reg [7:0] p5;
    reg [7:0] p6;
    reg [7:0] p7;
    reg [7:0] p8;
    wire [7:0] median_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .p0(p0),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6),
        .p7(p7),
        .p8(p8),
        .median_out(median_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            p0 = 0; p1 = 0; p2 = 0; p3 = 0; p4 = 0; p5 = 0; p6 = 0; p7 = 0; p8 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: All values same (0xAA)");
            p0 = 8'hAA; p1 = 8'hAA; p2 = 8'hAA; p3 = 8'hAA; p4 = 8'hAA;
            p5 = 8'hAA; p6 = 8'hAA; p7 = 8'hAA; p8 = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: Ordered sequence 1 to 9");
            p0 = 1; p1 = 2; p2 = 3; p3 = 4; p4 = 5; p5 = 6; p6 = 7; p7 = 8; p8 = 9;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Reverse ordered sequence");
            p0 = 90; p1 = 80; p2 = 70; p3 = 60; p4 = 50; p5 = 40; p6 = 30; p7 = 20; p8 = 10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Shuffled values [5,2,8,1,9,3,7,4,6]");
            p0 = 5; p1 = 2; p2 = 8; p3 = 1; p4 = 9; p5 = 3; p6 = 7; p7 = 4; p8 = 6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Duplicate values [100, 5, 100, 20, 5, 50, 50, 50, 1]");
            p0 = 100; p1 = 5; p2 = 100; p3 = 20; p4 = 5; p5 = 50; p6 = 50; p7 = 50; p8 = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: Min/Max values [0, 255, 0, 255, 0, 255, 0, 255, 128]");
            p0 = 0; p1 = 255; p2 = 0; p3 = 255; p4 = 0; p5 = 255; p6 = 0; p7 = 255; p8 = 128;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 007: All zeros");
            p0 = 0; p1 = 0; p2 = 0; p3 = 0; p4 = 0; p5 = 0; p6 = 0; p7 = 0; p8 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_median_out;
        begin
            if (expected_median_out === (expected_median_out ^ median_out ^ expected_median_out)) begin
                $display("PASS");
                $display("  Outputs: median_out=%h",
                         median_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: median_out=%h",
                         expected_median_out);
                $display("  Got:      median_out=%h",
                         median_out);
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
        $dumpvars(0,clk, p0, p1, p2, p3, p4, p5, p6, p7, p8, median_out);
    end

endmodule
