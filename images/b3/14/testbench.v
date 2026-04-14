`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg pulse;
    reg reset;
    wire [15:0] countOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .pulse(pulse),
        .reset(reset),
        .countOut(countOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        pulse = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Increment", test_num);
        reset_dut();
        pulse = 1;
        @(posedge clock);
        #1 pulse = 0;
        @(posedge clock);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Non-Consecutive Pulses", test_num);
        reset_dut();
        for (i = 0; i < 5; i = i + 1) begin
            pulse = 1;
            @(posedge clock);
            #1 pulse = 0;
            repeat(2) @(posedge clock);
            #1;
        end
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Counting (Pulse held high)", test_num);
        reset_dut();
        pulse = 1;
        repeat(10) @(posedge clock);
        #1 pulse = 0;
        @(posedge clock);
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count to 255", test_num);
        reset_dut();
        pulse = 1;
        repeat(255) @(posedge clock);
        #1 pulse = 0;
        @(posedge clock);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-operation Reset", test_num);
        reset_dut();
        pulse = 1;
        repeat(20) @(posedge clock);
        #1 reset = 1;
        @(posedge clock);
        #1 reset = 0;
        pulse = 0;
        @(posedge clock);
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_countOut;
        begin
            if (expected_countOut === (expected_countOut ^ countOut ^ expected_countOut)) begin
                $display("PASS");
                $display("  Outputs: countOut=%h",
                         countOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: countOut=%h",
                         expected_countOut);
                $display("  Got:      countOut=%h",
                         countOut);
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
        $dumpvars(0,clock, pulse, reset, countOut);
    end

endmodule
