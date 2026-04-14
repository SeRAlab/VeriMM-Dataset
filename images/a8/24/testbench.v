`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CMD_DONE;
    reg KEY_ADD;
    reg KEY_CLEAR;
    reg KEY_SUB;
    reg RESET;
    wire CMD_CLEAR;
    wire CMD_COMPUTE;
    wire CMD_OPERATION;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CMD_DONE(CMD_DONE),
        .KEY_ADD(KEY_ADD),
        .KEY_CLEAR(KEY_CLEAR),
        .KEY_SUB(KEY_SUB),
        .RESET(RESET),
        .CMD_CLEAR(CMD_CLEAR),
        .CMD_COMPUTE(CMD_COMPUTE),
        .CMD_OPERATION(CMD_OPERATION)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            KEY_CLEAR = 0;
            KEY_ADD = 0;
            KEY_SUB = 0;
            CMD_DONE = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: KEY_CLEAR Command");
            test_num = 2;
            reset_dut();
            KEY_CLEAR = 1;
            @(posedge CLK);
            #1 KEY_CLEAR = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: KEY_ADD Command");
            test_num = 3;
            reset_dut();
            KEY_ADD = 1;
            @(posedge CLK);
            #1 KEY_ADD = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: KEY_SUB Command");
            test_num = 4;
            reset_dut();
            KEY_SUB = 1;
            @(posedge CLK);
            #1 KEY_SUB = 0;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full Addition Sequence with CMD_DONE");
            test_num = 5;
            reset_dut();


            KEY_ADD = 1;
            @(posedge CLK);
            #1 KEY_ADD = 0;


            @(posedge CLK);
            #1;


            CMD_DONE = 1;
            @(posedge CLK);
            #1 CMD_DONE = 0;


            @(posedge CLK);
            @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Consecutive Commands (Clear then Sub)");
            test_num = 6;
            reset_dut();


            KEY_CLEAR = 1;
            @(posedge CLK);
            #1 KEY_CLEAR = 0;
            repeat(4) @(posedge CLK);


            #1 KEY_SUB = 1;
            @(posedge CLK);
            #1 KEY_SUB = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_CMD_CLEAR;
        input expected_CMD_COMPUTE;
        input expected_CMD_OPERATION;
        begin
            if (expected_CMD_CLEAR === (expected_CMD_CLEAR ^ CMD_CLEAR ^ expected_CMD_CLEAR) &&
                expected_CMD_COMPUTE === (expected_CMD_COMPUTE ^ CMD_COMPUTE ^ expected_CMD_COMPUTE) &&
                expected_CMD_OPERATION === (expected_CMD_OPERATION ^ CMD_OPERATION ^ expected_CMD_OPERATION)) begin
                $display("PASS");
                $display("  Outputs: CMD_CLEAR=%b, CMD_COMPUTE=%b, CMD_OPERATION=%b",
                         CMD_CLEAR, CMD_COMPUTE, CMD_OPERATION);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CMD_CLEAR=%b, CMD_COMPUTE=%b, CMD_OPERATION=%b",
                         expected_CMD_CLEAR, expected_CMD_COMPUTE, expected_CMD_OPERATION);
                $display("  Got:      CMD_CLEAR=%b, CMD_COMPUTE=%b, CMD_OPERATION=%b",
                         CMD_CLEAR, CMD_COMPUTE, CMD_OPERATION);
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
        $dumpvars(0,CLK, CMD_DONE, KEY_ADD, KEY_CLEAR, KEY_SUB, RESET, CMD_CLEAR, CMD_COMPUTE, CMD_OPERATION);
    end

endmodule
