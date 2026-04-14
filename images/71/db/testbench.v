`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg TE;
    wire ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .ENCLK(ENCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            TE = 0;
            @(negedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            EN = 0;
            TE = 0;

            @(posedge CLK);
            #2;
            $display("Testcase 001: Clock Gating (EN=0, TE=0)");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            EN = 1;
            TE = 0;

            @(posedge CLK);
            #2;
            $display("Testcase 002: Clock Enabled (EN=1, TE=0)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            EN = 0;
            TE = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 003: Clock Enabled via Test Enable (EN=0, TE=1)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            EN = 1;
            TE = 1;
            @(posedge CLK);
            #2;
            $display("Testcase 004: Both Enables High (EN=1, TE=1)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            EN = 0;
            TE = 0;
            @(posedge CLK);
            #1;
            EN = 1;
            #1;
            $display("Testcase 005: Glitch Prevention (EN changes 0->1 during CLK high)");
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
        input expected_ENCLK;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b",
                         ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b",
                         expected_ENCLK);
                $display("  Got:      ENCLK=%b",
                         ENCLK);
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
        $dumpvars(0,CLK, EN, TE, ENCLK);
    end

endmodule
