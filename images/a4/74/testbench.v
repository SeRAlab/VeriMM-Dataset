`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] d;
    reg l;
    wire D0;
    wire D1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .l(l),
        .D0(D0),
        .D1(D1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: From State Q (001), l=0 -> Next State S (D2=1, D1=0, D0=0)", test_num);
            d = 3'b001;
            l = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: From State Q (001), l=1 -> Next State R (D2=0, D1=1, D0=0)", test_num);
            d = 3'b001;
            l = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: From State R (010), l=0 -> Next State Q (D2=0, D1=0, D0=1)", test_num);
            d = 3'b010;
            l = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: From State R (010), l=1 -> Next State S (D2=1, D1=0, D0=0)", test_num);
            d = 3'b010;
            l = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: From State S (100), l=0 -> Next State R (D2=0, D1=1, D0=0)", test_num);
            d = 3'b100;
            l = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: From State S (100), l=1 -> Next State Q (D2=0, D1=0, D0=1)", test_num);
            d = 3'b100;
            l = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All-zero input state, l=0 -> All-zero next state", test_num);
            d = 3'b000;
            l = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All-zero input state, l=1 -> All-zero next state", test_num);
            d = 3'b000;
            l = 1'b1;
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
        input expected_D0;
        input expected_D1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D0 === (expected_D0 ^ D0 ^ expected_D0) &&
                expected_D1 === (expected_D1 ^ D1 ^ expected_D1)) begin
                $display("PASS");
                $display("  Outputs: D0=%b, D1=%b",
                         D0, D1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D0=%b, D1=%b",
                         expected_D0, expected_D1);
                $display("  Got:      D0=%b, D1=%b",
                         D0, D1);
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
