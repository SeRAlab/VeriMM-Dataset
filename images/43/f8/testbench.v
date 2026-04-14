`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iRST;
    wire oRST_0;
    wire oRST_1;
    wire oRST_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iRST(iRST),
        .oRST_0(oRST_0),
        .oRST_1(oRST_1),
        .oRST_2(oRST_2)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            $display("--- Resetting DUT ---");
            iRST = 1'b0;
            repeat (10) @(posedge iCLK);
            iRST = 1'b1;
            repeat (1) @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Asserting reset and checking initial state", test_num);
            iRST = 1'b0;
            repeat (20) @(posedge iCLK);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking outputs shortly after master reset release", test_num);
            reset_dut();

            repeat (5) @(posedge iCLK);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking outputs after long delay (Steady State)", test_num);
            reset_dut();


            repeat (10000) @(posedge iCLK);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Re-asserting reset after steady state", test_num);
            reset_dut();
            repeat (10000) @(posedge iCLK);
            iRST = 1'b0;
            repeat (5) @(posedge iCLK);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_oRST_0;
        input expected_oRST_1;
        input expected_oRST_2;
        begin
            if (expected_oRST_0 === (expected_oRST_0 ^ oRST_0 ^ expected_oRST_0) &&
                expected_oRST_1 === (expected_oRST_1 ^ oRST_1 ^ expected_oRST_1) &&
                expected_oRST_2 === (expected_oRST_2 ^ oRST_2 ^ expected_oRST_2)) begin
                $display("PASS");
                $display("  Outputs: oRST_0=%b, oRST_1=%b, oRST_2=%b",
                         oRST_0, oRST_1, oRST_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRST_0=%b, oRST_1=%b, oRST_2=%b",
                         expected_oRST_0, expected_oRST_1, expected_oRST_2);
                $display("  Got:      oRST_0=%b, oRST_1=%b, oRST_2=%b",
                         oRST_0, oRST_1, oRST_2);
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
        $dumpvars(0,iCLK, iRST, oRST_0, oRST_1, oRST_2);
    end

endmodule
