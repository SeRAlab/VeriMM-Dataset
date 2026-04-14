`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] g;
    reg p;
    wire G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .p(p),
        .G(G)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: State P (00), p=0. Expect G=1 (Next state R=10)", test_num);
        g = 2'b00; p = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: State P (00), p=1. Expect G=0 (Next state Q=01)", test_num);
        g = 2'b00; p = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: State Q (01), p=0. Expect G=0 (Next state P=00)", test_num);
        g = 2'b01; p = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: State Q (01), p=1. Expect G=1 (Next state S=11)", test_num);
        g = 2'b01; p = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: State R (10), p=0. Expect G=1 (Next state S=11)", test_num);
        g = 2'b10; p = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: State R (10), p=1. Expect G=0 (Next state P=00)", test_num);
        g = 2'b10; p = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: State S (11), p=0. Expect G=0 (Next state Q=01)", test_num);
        g = 2'b11; p = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: State S (11), p=1. Expect G=1 (Next state R=10)", test_num);
        g = 2'b11; p = 1'b1;
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
        input expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%b",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%b",
                         expected_G);
                $display("  Got:      G=%b",
                         G);
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
