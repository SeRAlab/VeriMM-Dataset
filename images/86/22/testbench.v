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
            test_num = 1;
            reset_dut();
            enable = 0;
            val = 4'h8;
            sidx = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable Low", test_num);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 1;
            val = 4'h0;
            sidx = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Value 0 on Digit 0", test_num);
            #1;

            check_outputs(8'h01, 8'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 1;
            val = 4'h1;
            sidx = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Value 1 on Digit 1", test_num);
            #1;

            check_outputs(8'h02, 8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            val = 4'h5;
            sidx = 3'd2;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Value 5 on Digit 2", test_num);
            #1;

            check_outputs(8'h04, 8'h6D);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            val = 4'h9;
            sidx = 3'd3;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Value 9 on Digit 3", test_num);
            #1;

            check_outputs(8'h08, 8'h6F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable = 1;
            val = 4'hA;
            sidx = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Value A on Digit 0", test_num);
            #1;

            check_outputs(8'h01, 8'h77);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable = 1;
            val = 4'h7;
            sidx = 3'd1;
            @(posedge clk);
            #1;
            val = 4'h3;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sequential update Value 3 on Digit 1", test_num);
            #1;

            check_outputs(8'h02, 8'h4F);
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
