`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClk;
    reg iSignal;
    wire oSignal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClk(iClk),
        .iSignal(iSignal),
        .oSignal(oSignal)
    );

    // Clock generation (10ns period)
    initial begin
        iClk = 0;
        forever #5 iClk = ~iClk;
    end

        task reset_dut;

        begin
            iSignal = 0;
            @(posedge iClk);
            @(posedge iClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Detecting Rising Edge (0 -> 1)", test_num);
            @(negedge iClk);
            iSignal = 1;
            @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Falling Edge (1 -> 0)", test_num);

            @(negedge iClk);
            iSignal = 1;
            @(posedge iClk);

            @(negedge iClk);
            iSignal = 0;
            @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Steady State High (1 -> 1)", test_num);

            @(negedge iClk);
            iSignal = 1;
            @(posedge iClk);

            @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Steady State Low (0 -> 0)", test_num);
            @(negedge iClk);
            iSignal = 0;
            @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Successive Rising Edges", test_num);

            @(negedge iClk); iSignal = 1;
            @(posedge iClk);

            @(negedge iClk); iSignal = 0;
            @(posedge iClk);

            @(negedge iClk); iSignal = 1;
            @(posedge iClk);
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
        input expected_oSignal;
        begin
            if (expected_oSignal === (expected_oSignal ^ oSignal ^ expected_oSignal)) begin
                $display("PASS");
                $display("  Outputs: oSignal=%b",
                         oSignal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSignal=%b",
                         expected_oSignal);
                $display("  Got:      oSignal=%b",
                         oSignal);
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
        $dumpvars(0,iClk, iSignal, oSignal);
    end

endmodule
