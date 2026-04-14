`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c12;
    reg c13;
    reg c14;
    reg c15;
    reg c16;
    reg c5;
    reg c6;
    reg c7;
    reg c8;
    wire intr;
    wire sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c12(c12),
        .c13(c13),
        .c14(c14),
        .c15(c15),
        .c16(c16),
        .c5(c5),
        .c6(c6),
        .c7(c7),
        .c8(c8),
        .intr(intr),
        .sync(sync)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs low", test_num);
        c5 = 0; c6 = 0; c7 = 0; c8 = 0;
        c12 = 0; c13 = 0; c14 = 0; c15 = 0; c16 = 0;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All inputs high", test_num);
        c5 = 1; c6 = 1; c7 = 1; c8 = 1;
        c12 = 1; c13 = 1; c14 = 1; c15 = 1; c16 = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Condition group 5-8 active, 12-16 inactive", test_num);
        c5 = 1; c6 = 1; c7 = 1; c8 = 1;
        c12 = 0; c13 = 0; c14 = 0; c15 = 0; c16 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Condition group 5-8 inactive, 12-16 active", test_num);
        c5 = 0; c6 = 0; c7 = 0; c8 = 0;
        c12 = 1; c13 = 1; c14 = 1; c15 = 1; c16 = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Alternating bit pattern", test_num);
        c5 = 1; c6 = 0; c7 = 1; c8 = 0;
        c12 = 1; c13 = 0; c14 = 1; c15 = 0; c16 = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Single bit trigger c12", test_num);
        c5 = 0; c6 = 0; c7 = 0; c8 = 0;
        c12 = 1; c13 = 0; c14 = 0; c15 = 0; c16 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Single bit trigger c5", test_num);
        c5 = 1; c6 = 0; c7 = 0; c8 = 0;
        c12 = 0; c13 = 0; c14 = 0; c15 = 0; c16 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Random logic combination", test_num);
        c5 = 1; c6 = 1; c7 = 0; c8 = 0;
        c12 = 0; c13 = 1; c14 = 1; c15 = 0; c16 = 0;
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_intr;
        input expected_sync;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_intr === (expected_intr ^ intr ^ expected_intr) &&
                expected_sync === (expected_sync ^ sync ^ expected_sync)) begin
                $display("PASS");
                $display("  Outputs: intr=%b, sync=%b",
                         intr, sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intr=%b, sync=%b",
                         expected_intr, expected_sync);
                $display("  Got:      intr=%b, sync=%b",
                         intr, sync);
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
