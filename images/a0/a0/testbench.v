`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [6:0] NOTE;
    wire [31:0] ADDER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .NOTE(NOTE),
        .ADDER(ADDER)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            NOTE = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Testing Note 0 (Lowest octave, Max shift)", test_num);
            NOTE = 7'd0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(calculate_expected(0));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Testing Note 60 (Middle segment)", test_num);
            NOTE = 7'd60;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(calculate_expected(60));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Testing Note 110 (High octave, Min shift)", test_num);
            NOTE = 7'd110;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(calculate_expected(110));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Testing Boundary Note 12 (Start of next segment)", test_num);
            NOTE = 7'd12;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(calculate_expected(12));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Testing Max Note 127", test_num);
            NOTE = 7'd127;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(calculate_expected(127));
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
        input [31:0] expected_ADDER;
        begin
            if (expected_ADDER === (expected_ADDER ^ ADDER ^ expected_ADDER)) begin
                $display("PASS");
                $display("  Outputs: ADDER=%h",
                         ADDER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDER=%h",
                         expected_ADDER);
                $display("  Got:      ADDER=%h",
                         ADDER);
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
        $dumpvars(0,CLK, NOTE, ADDER);
    end

endmodule
