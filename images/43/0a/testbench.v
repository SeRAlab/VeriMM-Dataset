`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] digit_0;
    reg [6:0] digit_1;
    reg [6:0] digit_2;
    reg [6:0] digit_3;
    reg reset_;
    wire [3:0] digit_enable_;
    wire [6:0] segment_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .digit_0(digit_0),
        .digit_1(digit_1),
        .digit_2(digit_2),
        .digit_3(digit_3),
        .reset_(reset_),
        .digit_enable_(digit_enable_),
        .segment_(segment_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_ = 0;
            digit_0 = 7'b0000000;
            digit_1 = 7'b0000000;
            digit_2 = 7'b0000000;
            digit_3 = 7'b0000000;
            #12;
            reset_ = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State - Digit 0 Selection", test_num);
            reset_dut();
            digit_0 = 7'b1010101;
            #1;

            #1;


            check_outputs(4'b1110, ~7'b1010101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle to Digit 1", test_num);
            reset_dut();
            digit_1 = 7'b1110000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101, ~7'b1110000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle to Digit 2", test_num);
            reset_dut();
            digit_2 = 7'b0000111;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1011, ~7'b0000111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle to Digit 3", test_num);
            reset_dut();
            digit_3 = 7'b0101010;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0111, ~7'b0101010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around check", test_num);
            reset_dut();
            digit_0 = 7'b1111111;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1110, ~7'b1111111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Isolation check", test_num);
            reset_dut();
            digit_0 = 7'b1100110;
            digit_1 = 7'b0011001;
            #1;

            #1;


            check_outputs(4'b1110, ~7'b1100110);
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
        input [3:0] expected_digit_enable_;
        input [6:0] expected_segment_;
        begin
            if (expected_digit_enable_ === (expected_digit_enable_ ^ digit_enable_ ^ expected_digit_enable_) &&
                expected_segment_ === (expected_segment_ ^ segment_ ^ expected_segment_)) begin
                $display("PASS");
                $display("  Outputs: digit_enable_=%h, segment_=%h",
                         digit_enable_, segment_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit_enable_=%h, segment_=%h",
                         expected_digit_enable_, expected_segment_);
                $display("  Got:      digit_enable_=%h, segment_=%h",
                         digit_enable_, segment_);
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
        $dumpvars(0,clk, digit_0, digit_1, digit_2, digit_3, reset_, digit_enable_, segment_);
    end

endmodule
