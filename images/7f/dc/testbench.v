`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg reset;
    wire [3:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        enable = 0;
        reset = 1;
        @(posedge clock);
        #1;
        reset = 0;

        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset State", test_num);
        reset_dut();


        #1;



        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Increment", test_num);
        reset_dut();
        enable = 1;
        @(posedge clock);
        #1;
        enable = 0;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Increment to 5", test_num);
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clock);
        #1;
        enable = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable/Disable Toggle", test_num);
        reset_dut();
        enable = 1;
        repeat(3) @(posedge clock);
        #1;
        enable = 0;
        repeat(5) @(posedge clock);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Counter Wrap-around (0..15..0)", test_num);
        reset_dut();
        enable = 1;
        repeat(16) @(posedge clock);
        #1;
        enable = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Wrap-around and continue to 2", test_num);
        reset_dut();
        enable = 1;
        repeat(18) @(posedge clock);
        #1;
        enable = 0;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Reset Priority over Enable", test_num);
        reset_dut();
        enable = 1;
        repeat(4) @(posedge clock);
        #1;
        reset = 1;
        @(posedge clock);
        #1;
        reset = 0;
        enable = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Count to 15", test_num);
        reset_dut();
        enable = 1;
        repeat(15) @(posedge clock);
        #1;
        enable = 0;
        #1;

        check_outputs(4'hF);
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
        testcase008();
        
        
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
        input [3:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,clock, enable, reset, counter_out);
    end

endmodule
