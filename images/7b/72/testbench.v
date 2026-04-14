`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg ENABLE;
    wire [9:0] TIME_COUNT;
    wire TRIGGER_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ENABLE(ENABLE),
        .TIME_COUNT(TIME_COUNT),
        .TRIGGER_OUT(TRIGGER_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ENABLE = 0;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment (10 cycles)", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Pause on ENABLE=0", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(5) @(posedge CLK);
            ENABLE = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: TRIGGER_OUT at Max-1 (798)", test_num);
            reset_dut();


            ENABLE = 1;
            repeat(798) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'd798, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter at Max Value (799)", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(799) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'd799, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wraparound to Zero", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(800) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'd0, 1'b0);
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
        input [9:0] expected_TIME_COUNT;
        input expected_TRIGGER_OUT;
        begin
            if (expected_TIME_COUNT === (expected_TIME_COUNT ^ TIME_COUNT ^ expected_TIME_COUNT) &&
                expected_TRIGGER_OUT === (expected_TRIGGER_OUT ^ TRIGGER_OUT ^ expected_TRIGGER_OUT)) begin
                $display("PASS");
                $display("  Outputs: TIME_COUNT=%h, TRIGGER_OUT=%b",
                         TIME_COUNT, TRIGGER_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TIME_COUNT=%h, TRIGGER_OUT=%b",
                         expected_TIME_COUNT, expected_TRIGGER_OUT);
                $display("  Got:      TIME_COUNT=%h, TRIGGER_OUT=%b",
                         TIME_COUNT, TRIGGER_OUT);
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
        $dumpvars(0,CLK, ENABLE, TIME_COUNT, TRIGGER_OUT);
    end

endmodule
