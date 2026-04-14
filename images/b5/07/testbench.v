`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR)
    );

        task reset_dut;

        begin
            SW[0] = 1;
            SW[1] = 0;
            KEY[0] = 0;
            #10;
            KEY[0] = 1;
            #10;
            SW[0] = 0;
            #10;
        end
        endtask
    task pulse_clock;

        begin
            KEY[0] = 0;
            #10;
            KEY[0] = 1;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            SW[1] = 0;
            pulse_clock();

            #1;


            check_outputs(10'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            SW[1] = 1;
            pulse_clock();

            #1;


            check_outputs(10'h206);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            SW[1] = 0;
            pulse_clock();
            pulse_clock();
            pulse_clock();
            pulse_clock();
            pulse_clock();

            #1;


            check_outputs(10'h205);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            SW[1] = 0;
            pulse_clock();
            pulse_clock();
            SW[1] = 1;
            pulse_clock();

            #1;


            check_outputs(10'h206);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            SW[1] = 0;
            pulse_clock(); pulse_clock(); pulse_clock();
            pulse_clock(); pulse_clock();
            pulse_clock();
            #1;

            check_outputs(10'h205);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            SW[1] = 0;
            pulse_clock(); pulse_clock();
            SW[0] = 1;
            pulse_clock();
            SW[0] = 0;

            #1;


            check_outputs(10'h000);
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
        input [9:0] expected_LEDR;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
        $dumpvars(0,KEY, SW, LEDR);
    end

endmodule
