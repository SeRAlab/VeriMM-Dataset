`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLEAR;
    reg CLOCK;
    reg DATA;
    reg PRESET;
    reg SLAVE_CLOCK;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLEAR(CLEAR),
        .CLOCK(CLOCK),
        .DATA(DATA),
        .PRESET(PRESET),
        .SLAVE_CLOCK(SLAVE_CLOCK),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLEAR = 0;
        forever #5 CLEAR = ~CLEAR;
    end

        task reset_dut;

        begin
            CLEAR = 1;
            PRESET = 0;
            DATA = 0;
            CLOCK = 0;
            SLAVE_CLOCK = 0;
            #10;
            CLEAR = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            PRESET = 1;
            #10;
            #1;

            check_outputs(1);
            PRESET = 0;
            #5;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            DATA = 1;
            #5;
            CLOCK = 1;
            #10;
            CLOCK = 0;
            #5;
            SLAVE_CLOCK = 1;
            #10;
            SLAVE_CLOCK = 0;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            PRESET = 1; #5; PRESET = 0; #5;


            DATA = 0;
            #5;
            CLOCK = 1;
            #10;
            CLOCK = 0;
            #5;
            SLAVE_CLOCK = 1;
            #10;
            SLAVE_CLOCK = 0;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            PRESET = 1;
            CLEAR = 1;
            #10;
            #1;

            check_outputs(0);
            CLEAR = 0;
            #5;
            #1;

            check_outputs(1);
            PRESET = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            DATA = 1;
            CLOCK = 1;
            #5;
            CLEAR = 1;
            #5;
            SLAVE_CLOCK = 1;
            #5;
            #1;

            check_outputs(0);
            CLEAR = 0;
            SLAVE_CLOCK = 0;
            CLOCK = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            DATA = 1;
            CLOCK = 1;
            #5;
            CLOCK = 0;
            #5;

            #1;


            check_outputs(0);
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
        input expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
        $dumpvars(0,CLEAR, CLOCK, DATA, PRESET, SLAVE_CLOCK, OUT);
    end

endmodule
