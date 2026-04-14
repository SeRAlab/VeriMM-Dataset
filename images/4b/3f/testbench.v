`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] h;
    reg y;
    wire H2;
    wire H3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .y(y),
        .H2(H2),
        .H3(H3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State P (h=3'b001), input y=0 -> Expected Next State Q (H2=1, H3=0)", test_num);
            h = 3'b001;
            y = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State P (h=3'b001), input y=1 -> Expected Next State R (H2=0, H3=1)", test_num);
            h = 3'b001;
            y = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State Q (h=3'b010), input y=0 -> Expected Next State P (H2=0, H3=0)", test_num);
            h = 3'b010;
            y = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State Q (h=3'b010), input y=1 -> Expected Next State R (H2=0, H3=1)", test_num);
            h = 3'b010;
            y = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State R (h=3'b100), input y=0 -> Expected Next State Q (H2=1, H3=0)", test_num);
            h = 3'b100;
            y = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State R (h=3'b100), input y=1 -> Expected Next State P (H2=0, H3=0)", test_num);
            h = 3'b100;
            y = 1;
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
        input expected_H2;
        input expected_H3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_H2 === (expected_H2 ^ H2 ^ expected_H2) &&
                expected_H3 === (expected_H3 ^ H3 ^ expected_H3)) begin
                $display("PASS");
                $display("  Outputs: H2=%b, H3=%b",
                         H2, H3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: H2=%b, H3=%b",
                         expected_H2, expected_H3);
                $display("  Got:      H2=%b, H3=%b",
                         H2, H3);
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
