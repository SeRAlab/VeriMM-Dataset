`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fx3_clock;
    reg nReset;
    reg readData;
    wire fx3isReading;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fx3_clock(fx3_clock),
        .nReset(nReset),
        .readData(readData),
        .fx3isReading(fx3isReading)
    );

    // Clock generation (10ns period)
    initial begin
        fx3_clock = 0;
        forever #5 fx3_clock = ~fx3_clock;
    end

        task reset_dut;

        begin
            nReset = 0;
            readData = 0;
            @(posedge fx3_clock);
            #1;
            nReset = 1;
            @(posedge fx3_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition to Reading State", test_num);
            reset_dut();
            @(posedge fx3_clock);
            readData = 1;
            @(posedge fx3_clock);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition back to Idle State", test_num);
            reset_dut();
            @(posedge fx3_clock);
            readData = 1;
            @(posedge fx3_clock);
            #1;
            readData = 0;
            @(posedge fx3_clock);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sustained Reading State", test_num);
            reset_dut();
            @(posedge fx3_clock);
            readData = 1;
            repeat(5) @(posedge fx3_clock);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during Reading State", test_num);
            reset_dut();
            @(posedge fx3_clock);
            readData = 1;
            @(posedge fx3_clock);
            #1;
            nReset = 0;
            @(posedge fx3_clock);
            #1;

            #1;


            check_outputs(1'b0);
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
        input expected_fx3isReading;
        begin
            if (expected_fx3isReading === (expected_fx3isReading ^ fx3isReading ^ expected_fx3isReading)) begin
                $display("PASS");
                $display("  Outputs: fx3isReading=%b",
                         fx3isReading);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fx3isReading=%b",
                         expected_fx3isReading);
                $display("  Got:      fx3isReading=%b",
                         fx3isReading);
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
        $dumpvars(0,fx3_clock, nReset, readData, fx3isReading);
    end

endmodule
