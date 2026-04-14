`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] Ascii;
    reg Clock;
    reg LoadChar;
    reg Reset;
    wire [6:0] Char;
    wire New;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ascii(Ascii),
        .Clock(Clock),
        .LoadChar(LoadChar),
        .Reset(Reset),
        .Char(Char),
        .New(New)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            LoadChar = 0;
            Ascii = 7'b0;
            @(posedge Clock);
            #1 Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Ascii = 7'h41;
            LoadChar = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h41, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            Ascii = 7'h42;
            LoadChar = 1;
            @(posedge Clock);

            #1 Ascii = 7'h5A;
            LoadChar = 0;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(7'h42, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            Ascii = 7'h31;
            LoadChar = 1;
            @(posedge Clock);

            #1 Ascii = 7'h32;
            LoadChar = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(7'h32, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            Ascii = 7'h58;
            LoadChar = 1;
            @(posedge Clock);

            #1 Reset = 1;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(7'h00, 1'b0);
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
        input [6:0] expected_Char;
        input expected_New;
        begin
            if (expected_Char === (expected_Char ^ Char ^ expected_Char) &&
                expected_New === (expected_New ^ New ^ expected_New)) begin
                $display("PASS");
                $display("  Outputs: Char=%h, New=%b",
                         Char, New);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Char=%h, New=%b",
                         expected_Char, expected_New);
                $display("  Got:      Char=%h, New=%b",
                         Char, New);
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
        $dumpvars(0,Ascii, Clock, LoadChar, Reset, Char, New);
    end

endmodule
