`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClk;
    reg [7:0] iCounter;
    reg iEnable;
    reg iLoad;
    reg iReset;
    wire [7:0] oCounter;
    wire oReady;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClk(iClk),
        .iCounter(iCounter),
        .iEnable(iEnable),
        .iLoad(iLoad),
        .iReset(iReset),
        .oCounter(oCounter),
        .oReady(oReady)
    );

    // Clock generation (10ns period)
    initial begin
        iClk = 0;
        forever #5 iClk = ~iClk;
    end

        task reset_dut;

        begin
            iReset = 1;
            iLoad = 0;
            iEnable = 0;
            iCounter = 8'h00;
            @(negedge iClk);
            iReset = 0;
            @(negedge iClk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset condition check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load non-zero value without enable", test_num);
            reset_dut();
            iCounter = 8'h0A;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            @(negedge iClk);

            #1;


            check_outputs(8'h0A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Full countdown from 5", test_num);
            reset_dut();
            iCounter = 8'h05;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            iEnable = 1;
            repeat(5) @(negedge iClk);
            iEnable = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Partial countdown and pause", test_num);
            reset_dut();
            iCounter = 8'h14;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            iEnable = 1;
            repeat(10) @(negedge iClk);
            iEnable = 0;
            repeat(2) @(negedge iClk);

            #1;


            check_outputs(8'h0A, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Load new value while counting", test_num);
            reset_dut();
            iCounter = 8'h0F;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            iEnable = 1;
            repeat(5) @(negedge iClk);
            iCounter = 8'h05;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            repeat(2) @(negedge iClk);
            iEnable = 0;

            #1;


            check_outputs(8'h03, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable when already at zero", test_num);
            reset_dut();

            iEnable = 1;
            repeat(5) @(negedge iClk);
            iEnable = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Max value decrement test", test_num);
            reset_dut();
            iCounter = 8'hFF;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            iEnable = 1;
            repeat(2) @(negedge iClk);
            iEnable = 0;
            #1;

            check_outputs(8'hFD, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Reset during countdown", test_num);
            reset_dut();
            iCounter = 8'h0A;
            iLoad = 1;
            @(negedge iClk);
            iLoad = 0;
            iEnable = 1;
            repeat(5) @(negedge iClk);
            iReset = 1;
            @(negedge iClk);
            iReset = 0;

            #1;


            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_oCounter;
        input expected_oReady;
        begin
            if (expected_oCounter === (expected_oCounter ^ oCounter ^ expected_oCounter) &&
                expected_oReady === (expected_oReady ^ oReady ^ expected_oReady)) begin
                $display("PASS");
                $display("  Outputs: oCounter=%h, oReady=%b",
                         oCounter, oReady);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCounter=%h, oReady=%b",
                         expected_oCounter, expected_oReady);
                $display("  Got:      oCounter=%h, oReady=%b",
                         oCounter, oReady);
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
        $dumpvars(0,iClk, iCounter, iEnable, iLoad, iReset, oCounter, oReady);
    end

endmodule
