`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg x;
    wire fall;
    wire rise;
    wire toggle;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .x(x),
        .fall(fall),
        .rise(rise),
        .toggle(toggle),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            x = 0;
            @(posedge clock);
            #1;
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            x = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            x = 1;
            @(posedge clock);

            x = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            x = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            x = 1;
            @(posedge clock);

            x = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            x = 1;
            @(posedge clock);

            reset = 1;
            x = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            x = 1;
            @(posedge clock);
            x = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1, 0, 1, 0);
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
        input expected_fall;
        input expected_rise;
        input expected_toggle;
        input expected_z;
        begin
            if (expected_fall === (expected_fall ^ fall ^ expected_fall) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise) &&
                expected_toggle === (expected_toggle ^ toggle ^ expected_toggle) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: fall=%b, rise=%b, toggle=%b, z=%b",
                         fall, rise, toggle, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall=%b, rise=%b, toggle=%b, z=%b",
                         expected_fall, expected_rise, expected_toggle, expected_z);
                $display("  Got:      fall=%b, rise=%b, toggle=%b, z=%b",
                         fall, rise, toggle, z);
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
        $dumpvars(0,clock, reset, x, fall, rise, toggle, z);
    end

endmodule
