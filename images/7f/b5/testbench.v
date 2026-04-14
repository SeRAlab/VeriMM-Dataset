`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg [2:0] TEMP;
    reg [2:0] THRESHOLD;
    wire ALARM;
    wire COLD;
    wire HOT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .TEMP(TEMP),
        .THRESHOLD(THRESHOLD),
        .ALARM(ALARM),
        .COLD(COLD),
        .HOT(HOT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            TEMP = 0;
            THRESHOLD = 0;
            @(posedge CLK);
            #2;
            RESET = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature Above Threshold (HOT)", test_num);
            reset_dut();
            TEMP = 3'd5;
            THRESHOLD = 3'd2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature Below Threshold (COLD)", test_num);
            reset_dut();
            TEMP = 3'd1;
            THRESHOLD = 3'd4;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Temperature Equal to Threshold", test_num);
            reset_dut();
            TEMP = 3'd3;
            THRESHOLD = 3'd3;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Temp (7) vs Min Threshold (0)", test_num);
            reset_dut();
            TEMP = 3'd7;
            THRESHOLD = 3'd0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Temp (0) vs Max Threshold (7)", test_num);
            reset_dut();
            TEMP = 3'd0;
            THRESHOLD = 3'd7;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: RESET logic override check", test_num);
            RESET = 1;
            TEMP = 3'd7;
            THRESHOLD = 3'd2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 0, 0);
            RESET = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zero Inputs", test_num);
            reset_dut();
            TEMP = 3'd0;
            THRESHOLD = 3'd0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 0, 0);
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
        input expected_ALARM;
        input expected_COLD;
        input expected_HOT;
        begin
            if (expected_ALARM === (expected_ALARM ^ ALARM ^ expected_ALARM) &&
                expected_COLD === (expected_COLD ^ COLD ^ expected_COLD) &&
                expected_HOT === (expected_HOT ^ HOT ^ expected_HOT)) begin
                $display("PASS");
                $display("  Outputs: ALARM=%b, COLD=%b, HOT=%b",
                         ALARM, COLD, HOT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALARM=%b, COLD=%b, HOT=%b",
                         expected_ALARM, expected_COLD, expected_HOT);
                $display("  Got:      ALARM=%b, COLD=%b, HOT=%b",
                         ALARM, COLD, HOT);
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
        $dumpvars(0,CLK, RESET, TEMP, THRESHOLD, ALARM, COLD, HOT);
    end

endmodule
