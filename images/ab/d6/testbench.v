`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg TDOPPC;
    reg TDOTSPPC;
    wire TCK;
    wire TDIPPC;
    wire TMS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TDOPPC(TDOPPC),
        .TDOTSPPC(TDOTSPPC),
        .TCK(TCK),
        .TDIPPC(TDIPPC),
        .TMS(TMS)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: TDOPPC=0, TDOTSPPC=0", test_num);
        TDOPPC = 1'b0;
        TDOTSPPC = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: TDOPPC=1, TDOTSPPC=0", test_num);
        TDOPPC = 1'b1;
        TDOTSPPC = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: TDOPPC=0, TDOTSPPC=1", test_num);
        TDOPPC = 1'b0;
        TDOTSPPC = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: TDOPPC=1, TDOTSPPC=1", test_num);
        TDOPPC = 1'b1;
        TDOTSPPC = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Randomized toggle check", test_num);
        TDOPPC = 1'b0;
        TDOTSPPC = 1'b1;
        #5;
        TDOPPC = 1'b1;
        TDOTSPPC = 1'b0;
        #5;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_TCK;
        input expected_TDIPPC;
        input expected_TMS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_TCK === (expected_TCK ^ TCK ^ expected_TCK) &&
                expected_TDIPPC === (expected_TDIPPC ^ TDIPPC ^ expected_TDIPPC) &&
                expected_TMS === (expected_TMS ^ TMS ^ expected_TMS)) begin
                $display("PASS");
                $display("  Outputs: TCK=%b, TDIPPC=%b, TMS=%b",
                         TCK, TDIPPC, TMS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TCK=%b, TDIPPC=%b, TMS=%b",
                         expected_TCK, expected_TDIPPC, expected_TMS);
                $display("  Got:      TCK=%b, TDIPPC=%b, TMS=%b",
                         TCK, TDIPPC, TMS);
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
