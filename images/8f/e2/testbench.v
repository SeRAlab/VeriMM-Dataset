`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK100MHZ;
    reg [3:0] map;
    reg sw7;
    wire [5:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK100MHZ(CLK100MHZ),
        .map(map),
        .sw7(sw7),
        .min(min)
    );

    // Clock generation (10ns period)
    initial begin
        CLK100MHZ = 0;
        forever #5 CLK100MHZ = ~CLK100MHZ;
    end

        task reset_dut;

        begin
            sw7 = 0;
            map = 0;
            @(posedge CLK100MHZ);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(56);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            map = 10;
            sw7 = 0;
            @(posedge CLK100MHZ);
            #1;

            #1;


            check_outputs(46);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            map = 15;
            sw7 = 0;
            @(posedge CLK100MHZ);
            #1;

            #1;


            check_outputs(41);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            map = 5;
            sw7 = 0;
            @(posedge CLK100MHZ);
            #1;

            sw7 = 1;
            map = 12;
            @(posedge CLK100MHZ);
            #1;

            #1;


            check_outputs(51);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            sw7 = 1;
            map = 8;
            @(posedge CLK100MHZ);
            #1;

            sw7 = 0;
            @(posedge CLK100MHZ);
            #1;

            #1;


            check_outputs(48);
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
        input [5:0] expected_min;
        begin
            if (expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: min=%h",
                         min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h",
                         expected_min);
                $display("  Got:      min=%h",
                         min);
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
        $dumpvars(0,CLK100MHZ, map, sw7, min);
    end

endmodule
