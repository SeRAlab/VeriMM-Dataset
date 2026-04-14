`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] k;
    reg q;
    wire K2;
    wire K3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .q(q),
        .K2(K2),
        .K3(K3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: State T (3'b001), q=0 -> Expected K2=1, K3=0", test_num);
        k = 3'b001;
        q = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: State T (3'b001), q=1 -> Expected K2=0, K3=1", test_num);
        k = 3'b001;
        q = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: State U (3'b010), q=0 -> Expected K2=0, K3=0", test_num);
        k = 3'b010;
        q = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: State U (3'b010), q=1 -> Expected K2=0, K3=1", test_num);
        k = 3'b010;
        q = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: State V (3'b100), q=0 -> Expected K2=1, K3=0", test_num);
        k = 3'b100;
        q = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: State V (3'b100), q=1 -> Expected K2=0, K3=0", test_num);
        k = 3'b100;
        q = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Illegal state (3'b000), q=0 -> Expected K2=0, K3=0", test_num);
        k = 3'b000;
        q = 0;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_K2;
        input expected_K3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_K2 === (expected_K2 ^ K2 ^ expected_K2) &&
                expected_K3 === (expected_K3 ^ K3 ^ expected_K3)) begin
                $display("PASS");
                $display("  Outputs: K2=%b, K3=%b",
                         K2, K3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: K2=%b, K3=%b",
                         expected_K2, expected_K3);
                $display("  Got:      K2=%b, K3=%b",
                         K2, K3);
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
