`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    wire [6:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #100;
            $display("Testcase 001: Checking State 0 (Counter < 512)");
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            #5120;
            $display("Testcase 002: Checking State 1 (512 <= Counter < 1024)");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            #10240;
            $display("Testcase 003: Checking State 3 (1536 <= Counter < 2048)");
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            #20480;
            $display("Testcase 004: Checking State 7 (3584 <= Counter < 4096)");
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            #10000;
            $display("Testcase 005: Checking Wrap-around (Counter rolled back to 0)");
            #1;

            check_outputs(7'h3F);
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
        input [6:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,CLOCK_50, LED);
    end

endmodule
