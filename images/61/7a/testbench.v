`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg FlagC;
    reg FlagN;
    reg FlagV;
    reg bool0;
    wire comparison;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FlagC(FlagC),
        .FlagN(FlagN),
        .FlagV(FlagV),
        .bool0(bool0),
        .comparison(comparison)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: bool0=1, FlagC=0", test_num);
        bool0 = 1'b1;
        FlagC = 1'b0;
        FlagN = 1'b0;
        FlagV = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: bool0=1, FlagC=1", test_num);
        bool0 = 1'b1;
        FlagC = 1'b1;
        FlagN = 1'b1;
        FlagV = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: bool0=0, FlagN=0, FlagV=0", test_num);
        bool0 = 1'b0;
        FlagC = 1'b1;
        FlagN = 1'b0;
        FlagV = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: bool0=0, FlagN=0, FlagV=1", test_num);
        bool0 = 1'b0;
        FlagC = 1'b1;
        FlagN = 1'b0;
        FlagV = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: bool0=0, FlagN=1, FlagV=0", test_num);
        bool0 = 1'b0;
        FlagC = 1'b0;
        FlagN = 1'b1;
        FlagV = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: bool0=0, FlagN=1, FlagV=1", test_num);
        bool0 = 1'b0;
        FlagC = 1'b0;
        FlagN = 1'b1;
        FlagV = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: bool0=1, FlagC=0, testing FlagN/V independence", test_num);
        bool0 = 1'b1;
        FlagC = 1'b0;
        FlagN = 1'b1;
        FlagV = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: bool0=0, FlagN=1, FlagV=0, testing FlagC independence", test_num);
        bool0 = 1'b0;
        FlagC = 1'b1;
        FlagN = 1'b1;
        FlagV = 1'b0;
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
        input expected_comparison;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparison === (expected_comparison ^ comparison ^ expected_comparison)) begin
                $display("PASS");
                $display("  Outputs: comparison=%b",
                         comparison);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparison=%b",
                         expected_comparison);
                $display("  Got:      comparison=%b",
                         comparison);
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

endmodule
