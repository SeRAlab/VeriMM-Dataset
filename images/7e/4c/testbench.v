`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    reg [3:0] KEY;
    wire [8:0] LEDG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .LEDG(LEDG)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin
            KEY = 4'b0000;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            KEY[0] = 1;
            #2000;

            #1;


            check_outputs(9'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            KEY[0] = 1; #1000;
            KEY[0] = 0; #1000;

            KEY[0] = 1; #1000;

            #1;


            check_outputs(9'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            KEY[0] = 1; #1000;
            KEY[0] = 0; #1000;

            KEY[1] = 1; #2000;


            #1;



            check_outputs(9'h003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            KEY[0] = 1; #1000;
            KEY[0] = 0; #1000;

            KEY[1] = 1; #1000;
            KEY[1] = 0; #1000;

            KEY[1] = 1; #2000;

            #1;


            check_outputs(9'h007);
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
        input [8:0] expected_LEDG;
        begin
            if (expected_LEDG === (expected_LEDG ^ LEDG ^ expected_LEDG)) begin
                $display("PASS");
                $display("  Outputs: LEDG=%h",
                         LEDG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDG=%h",
                         expected_LEDG);
                $display("  Got:      LEDG=%h",
                         LEDG);
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
        $dumpvars(0,CLOCK_50, KEY, LEDG);
    end

endmodule
