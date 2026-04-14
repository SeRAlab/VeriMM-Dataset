`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg iReset;
    reg [7:0] iSeed;
    reg iSeedEnable;
    reg iShiftEnable;
    wire [7:0] oData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iReset(iReset),
        .iSeed(iSeed),
        .iSeedEnable(iSeedEnable),
        .iShiftEnable(iShiftEnable),
        .oData(oData)
    );

    // Clock generation (10ns period)
    initial begin
        iClock = 0;
        forever #5 iClock = ~iClock;
    end

        task reset_dut;

        begin
            iReset = 1;
            iSeed = 8'h00;
            iSeedEnable = 0;
            iShiftEnable = 0;
            @(posedge iClock);
            #1 iReset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State...", test_num);
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading Seed 8'hAA...", test_num);
            reset_dut();
            iSeed = 8'hAA;
            iSeedEnable = 1;
            @(posedge iClock);
            #1 iSeedEnable = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying data hold when ShiftEnable=0...", test_num);
            reset_dut();
            iSeed = 8'h55;
            iSeedEnable = 1;
            @(posedge iClock);
            #1 iSeedEnable = 0;
            iShiftEnable = 0;
            repeat(2) @(posedge iClock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single shift from 8'h01...", test_num);
            reset_dut();

            iShiftEnable = 1;
            @(posedge iClock);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying feedback shift (MSB XOR taps)...", test_num);
            reset_dut();
            iSeed = 8'h80;
            iSeedEnable = 1;
            @(posedge iClock);
            #1 iSeedEnable = 0;
            iShiftEnable = 1;
            @(posedge iClock);
            #1;



            #1;




            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying SeedEnable priority over ShiftEnable...", test_num);
            reset_dut();
            iSeed = 8'hCC;
            iSeedEnable = 1;
            iShiftEnable = 1;
            @(posedge iClock);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset priority over SeedEnable...", test_num);
            reset_dut();
            iReset = 1;
            iSeed = 8'hFF;
            iSeedEnable = 1;
            @(posedge iClock);
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Performing multiple shifts...", test_num);
            reset_dut();
            iShiftEnable = 1;
            repeat(3) @(posedge iClock);
            #1;

            #1;


            check_outputs(8'h08);
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
        input [7:0] expected_oData;
        begin
            if (expected_oData === (expected_oData ^ oData ^ expected_oData)) begin
                $display("PASS");
                $display("  Outputs: oData=%h",
                         oData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oData=%h",
                         expected_oData);
                $display("  Got:      oData=%h",
                         oData);
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
        $dumpvars(0,iClock, iReset, iSeed, iSeedEnable, iShiftEnable, oData);
    end

endmodule
