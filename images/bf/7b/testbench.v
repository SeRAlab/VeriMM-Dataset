`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg [1:0] SWITCHES;
    wire [3:0] LEDS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .SWITCHES(SWITCHES),
        .LEDS(LEDS)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        $display("--- Resetting DUT ---");
        RESET = 1;
        SWITCHES = 2'b00;
        #200;
        RESET = 0;
        #100;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Initial Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Increment LEDS", test_num);
        reset_dut();
        SWITCHES = 2'b01;
        #200;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiple Increments to 2", test_num);
        reset_dut();
        SWITCHES = 2'b01;
        #200;
        #200;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Decrement from 0 (Underflow)", test_num);
        reset_dut();
        SWITCHES = 2'b10;
        #200;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Priority Check (Both switches active)", test_num);
        reset_dut();
        SWITCHES = 2'b11;
        #200;


        #1;



        check_outputs(4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Idle State (No increment/decrement)", test_num);
        reset_dut();
        SWITCHES = 2'b01;
        #200;
        SWITCHES = 2'b00;
        #200;
        #200;
        #1;

        check_outputs(4'h1);
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
        input [3:0] expected_LEDS;
        begin
            if (expected_LEDS === (expected_LEDS ^ LEDS ^ expected_LEDS)) begin
                $display("PASS");
                $display("  Outputs: LEDS=%h",
                         LEDS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDS=%h",
                         expected_LEDS);
                $display("  Got:      LEDS=%h",
                         LEDS);
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
        $dumpvars(0,CLK, RESET, SWITCHES, LEDS);
    end

endmodule
