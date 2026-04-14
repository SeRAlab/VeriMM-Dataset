`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg GATE;
    reg SCE;
    wire GCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .GATE(GATE),
        .SCE(SCE),
        .GCLK(GCLK)
    );

        task reset_dut;

        begin
            SCE = 0;
            GATE = 0;
            @(negedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Operation (SCE=1, GATE=1)", test_num);
            reset_dut();

            SCE = 1;
            GATE = 1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: GATE suppressed (SCE=1, GATE=0)", test_num);
            reset_dut();

            SCE = 1;
            GATE = 0;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SCE suppressed (SCE=0, GATE=1)", test_num);
            reset_dut();

            SCE = 0;
            GATE = 1;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Glitch Prevention (Assert high while CLK=1)", test_num);
            reset_dut();

            @(posedge CLK);
            #2;
            SCE = 1;
            GATE = 1;
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Glitch Prevention (De-assert while CLK=1)", test_num);
            reset_dut();


            SCE = 1;
            GATE = 1;

            @(posedge CLK);
            #2;

            GATE = 0;
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_GCLK;
        begin
            if (expected_GCLK === (expected_GCLK ^ GCLK ^ expected_GCLK)) begin
                $display("PASS");
                $display("  Outputs: GCLK=%b",
                         GCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GCLK=%b",
                         expected_GCLK);
                $display("  Got:      GCLK=%b",
                         GCLK);
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
        $dumpvars(0,CLK, GATE, SCE, GCLK);
    end

endmodule
