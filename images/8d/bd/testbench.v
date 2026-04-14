`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg [3:0] countValue;
    reg dir;
    reg disp;
    reg enable;
    wire [15:0] outputValue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .countValue(countValue),
        .dir(dir),
        .disp(disp),
        .enable(enable),
        .outputValue(outputValue)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            disp = 1;
            dir = 0;
            countValue = 0;
            #12;
            clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clock);
            disp = 0;
            countValue = 16'hA5A5;
            @(posedge clock);
            #1;
            disp = 1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            dir = 1;
            repeat (10) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clock);
            disp = 0;
            countValue = 16'h0020;
            @(posedge clock);
            disp = 1;
            enable = 1;
            dir = 0;
            repeat (5) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h001B);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 0;
            dir = 1;
            repeat (10) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clock);
            disp = 0;
            countValue = 16'hFFFF;
            @(posedge clock);
            disp = 1;
            enable = 1;
            dir = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            dir = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(posedge clock);
            disp = 0;
            countValue = 16'h1234;
            enable = 1;
            dir = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1234);
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
        input [15:0] expected_outputValue;
        begin
            if (expected_outputValue === (expected_outputValue ^ outputValue ^ expected_outputValue)) begin
                $display("PASS");
                $display("  Outputs: outputValue=%h",
                         outputValue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputValue=%h",
                         expected_outputValue);
                $display("  Got:      outputValue=%h",
                         outputValue);
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
        $dumpvars(0,clear, clock, countValue, dir, disp, enable, outputValue);
    end

endmodule
