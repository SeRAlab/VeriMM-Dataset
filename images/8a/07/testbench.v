`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iRST;
    wire oRST_0;
    wire oRST_1;
    wire oRST_2;
    wire oRST_3;
    wire oRST_4;

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
        .oRST_2(oRST_2),
        .oRST_3(oRST_3),
        .oRST_4(oRST_4)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST = 1;
            repeat(5) @(posedge iCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Reset Release Sequence", test_num);
            reset_dut();
            iRST = 0;

            repeat(10) @(posedge iCLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold Reset Active", test_num);
            reset_dut();
            iRST = 1;
            repeat(5) @(posedge iCLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Staggered Release Propagation", test_num);
            reset_dut();
            iRST = 0;

            repeat(3) @(posedge iCLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Re-assertion Mid-Sequence", test_num);
            reset_dut();
            iRST = 0;
            repeat(2) @(posedge iCLK);
            iRST = 1;
            repeat(2) @(posedge iCLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_oRST_3;
        input expected_oRST_4;
        begin
            if (expected_oRST_0 === (expected_oRST_0 ^ oRST_0 ^ expected_oRST_0) &&
                expected_oRST_1 === (expected_oRST_1 ^ oRST_1 ^ expected_oRST_1) &&
                expected_oRST_2 === (expected_oRST_2 ^ oRST_2 ^ expected_oRST_2) &&
                expected_oRST_3 === (expected_oRST_3 ^ oRST_3 ^ expected_oRST_3) &&
                expected_oRST_4 === (expected_oRST_4 ^ oRST_4 ^ expected_oRST_4)) begin
                $display("PASS");
                $display("  Outputs: oRST_0=%b, oRST_1=%b, oRST_2=%b, oRST_3=%b, oRST_4=%b",
                         oRST_0, oRST_1, oRST_2, oRST_3, oRST_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRST_0=%b, oRST_1=%b, oRST_2=%b, oRST_3=%b, oRST_4=%b",
                         expected_oRST_0, expected_oRST_1, expected_oRST_2, expected_oRST_3, expected_oRST_4);
                $display("  Got:      oRST_0=%b, oRST_1=%b, oRST_2=%b, oRST_3=%b, oRST_4=%b",
                         oRST_0, oRST_1, oRST_2, oRST_3, oRST_4);
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
        $dumpvars(0,iCLK, iRST, oRST_0, oRST_1, oRST_2, oRST_3, oRST_4);
    end

endmodule
