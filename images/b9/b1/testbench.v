`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg subsig1;
    reg subsig2;
    wire subout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .subsig1(subsig1),
        .subsig2(subsig2),
        .subout(subout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: subsig1=0, subsig2=0", test_num);
        subsig1 = 1'b0;
        subsig2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: subsig1=1, subsig2=0", test_num);
        subsig1 = 1'b1;
        subsig2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: subsig1=0, subsig2=1", test_num);
        subsig1 = 1'b0;
        subsig2 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: subsig1=1, subsig2=1", test_num);
        subsig1 = 1'b1;
        subsig2 = 1'b1;
        #1;

        check_outputs(1'b0);
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
        input expected_subout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_subout === (expected_subout ^ subout ^ expected_subout)) begin
                $display("PASS");
                $display("  Outputs: subout=%b",
                         subout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subout=%b",
                         expected_subout);
                $display("  Got:      subout=%b",
                         subout);
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
