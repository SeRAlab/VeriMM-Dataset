`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] numbers;
    reg reset;
    wire [3:0] digit_select;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .numbers(numbers),
        .reset(reset),
        .digit_select(digit_select),
        .segments(segments)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            numbers = 16'h0000;
            @(posedge clk);
            #5;
            reset = 0;
            @(posedge clk);
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State (All segments/digits OFF)", test_num);

            reset = 1;
            numbers = 16'h1234;
            #20;



            #1;




            check_outputs(4'b1111, 7'b1111111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Digit 0 Mapping for value '0'", test_num);

            reset_dut();


            numbers = 16'h1230;
            #20;



            #1;




            check_outputs(4'b1110, 7'b1000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Digit 0 Mapping for value '1'", test_num);

            reset_dut();
            numbers = 16'h4321;
            #20;



            #1;




            check_outputs(4'b1110, 7'b1111001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Digit 0 Mapping for value '8'", test_num);

            reset_dut();
            numbers = 16'h9998;
            #20;



            #1;




            check_outputs(4'b1110, 7'b0000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Digit 0 Mapping for value '7'", test_num);

            reset_dut();
            numbers = 16'h0007;
            #20;



            #1;




            check_outputs(4'b1110, 7'b1111000);
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
        input [3:0] expected_digit_select;
        input [6:0] expected_segments;
        begin
            if (expected_digit_select === (expected_digit_select ^ digit_select ^ expected_digit_select) &&
                expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: digit_select=%h, segments=%h",
                         digit_select, segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit_select=%h, segments=%h",
                         expected_digit_select, expected_segments);
                $display("  Got:      digit_select=%h, segments=%h",
                         digit_select, segments);
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
        $dumpvars(0,clk, numbers, reset, digit_select, segments);
    end

endmodule
