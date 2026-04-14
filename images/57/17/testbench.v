`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg oe;
    reg padin;
    wire padout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .oe(oe),
        .padin(padin),
        .padout(padout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input padin=0, oe=0. Expecting padout=0.", test_num);
        padin = 1'b0;
        oe = 1'b0;
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input padin=1, oe=0. Expecting padout=1.", test_num);
        padin = 1'b1;
        oe = 1'b0;
        #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input padin=0, oe=1. Expecting padout=0.", test_num);
        padin = 1'b0;
        oe = 1'b1;
        #5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input padin=1, oe=1. Expecting padout=1.", test_num);
        padin = 1'b1;
        oe = 1'b1;
        #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Rapid Toggle padin. Expecting padout to follow.", test_num);
        padin = 1'b0; oe = 1'b1; #2;
        padin = 1'b1; #2;
        padin = 1'b0; #2;
        padin = 1'b1; #2;
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
        input expected_padout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_padout === (expected_padout ^ padout ^ expected_padout)) begin
                $display("PASS");
                $display("  Outputs: padout=%b",
                         padout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: padout=%b",
                         expected_padout);
                $display("  Got:      padout=%b",
                         padout);
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
