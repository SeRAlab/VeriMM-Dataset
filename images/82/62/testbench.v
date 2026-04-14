`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg STARTPULSE;
    wire DTROUT0;
    wire DTROUT1;
    wire DTROUT2;
    wire DTROUT3;
    wire DTROUT4;
    wire DTROUT5;
    wire DTROUT6;
    wire DTROUT7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .STARTPULSE(STARTPULSE),
        .DTROUT0(DTROUT0),
        .DTROUT1(DTROUT1),
        .DTROUT2(DTROUT2),
        .DTROUT3(DTROUT3),
        .DTROUT4(DTROUT4),
        .DTROUT5(DTROUT5),
        .DTROUT6(DTROUT6),
        .DTROUT7(DTROUT7)
    );

    // Clock generation (10ns period)
    initial begin
        STARTPULSE = 0;
        forever #5 STARTPULSE = ~STARTPULSE;
    end

        task reset_dut;

        begin




            @(negedge STARTPULSE);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: First pulse (Counter reaching 0)...");
            reset_dut();
            @(posedge STARTPULSE);
            #2;
            #1;

            check_outputs(1, 1, 1, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Second pulse (Counter reaching 1)...");
            reset_dut();
            @(posedge STARTPULSE);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Third pulse (Counter reaching 2)...");
            reset_dut();
            @(posedge STARTPULSE);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Fourth pulse (Counter reaching 3)...");
            reset_dut();
            @(posedge STARTPULSE);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Fifth pulse (Wrap around to 0)...");
            reset_dut();
            @(posedge STARTPULSE);
            #2;
            #1;

            check_outputs(1, 1, 1, 1, 1, 0, 0, 0);
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
        input expected_DTROUT0;
        input expected_DTROUT1;
        input expected_DTROUT2;
        input expected_DTROUT3;
        input expected_DTROUT4;
        input expected_DTROUT5;
        input expected_DTROUT6;
        input expected_DTROUT7;
        begin
            if (expected_DTROUT0 === (expected_DTROUT0 ^ DTROUT0 ^ expected_DTROUT0) &&
                expected_DTROUT1 === (expected_DTROUT1 ^ DTROUT1 ^ expected_DTROUT1) &&
                expected_DTROUT2 === (expected_DTROUT2 ^ DTROUT2 ^ expected_DTROUT2) &&
                expected_DTROUT3 === (expected_DTROUT3 ^ DTROUT3 ^ expected_DTROUT3) &&
                expected_DTROUT4 === (expected_DTROUT4 ^ DTROUT4 ^ expected_DTROUT4) &&
                expected_DTROUT5 === (expected_DTROUT5 ^ DTROUT5 ^ expected_DTROUT5) &&
                expected_DTROUT6 === (expected_DTROUT6 ^ DTROUT6 ^ expected_DTROUT6) &&
                expected_DTROUT7 === (expected_DTROUT7 ^ DTROUT7 ^ expected_DTROUT7)) begin
                $display("PASS");
                $display("  Outputs: DTROUT0=%b, DTROUT1=%b, DTROUT2=%b, DTROUT3=%b, DTROUT4=%b, DTROUT5=%b, DTROUT6=%b, DTROUT7=%b",
                         DTROUT0, DTROUT1, DTROUT2, DTROUT3, DTROUT4, DTROUT5, DTROUT6, DTROUT7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DTROUT0=%b, DTROUT1=%b, DTROUT2=%b, DTROUT3=%b, DTROUT4=%b, DTROUT5=%b, DTROUT6=%b, DTROUT7=%b",
                         expected_DTROUT0, expected_DTROUT1, expected_DTROUT2, expected_DTROUT3, expected_DTROUT4, expected_DTROUT5, expected_DTROUT6, expected_DTROUT7);
                $display("  Got:      DTROUT0=%b, DTROUT1=%b, DTROUT2=%b, DTROUT3=%b, DTROUT4=%b, DTROUT5=%b, DTROUT6=%b, DTROUT7=%b",
                         DTROUT0, DTROUT1, DTROUT2, DTROUT3, DTROUT4, DTROUT5, DTROUT6, DTROUT7);
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
        $dumpvars(0,STARTPULSE, DTROUT0, DTROUT1, DTROUT2, DTROUT3, DTROUT4, DTROUT5, DTROUT6, DTROUT7);
    end

endmodule
