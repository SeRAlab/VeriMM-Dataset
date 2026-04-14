`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire d1;
    wire [6:0] segmentos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d1(d1),
        .segmentos(segmentos)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 4'b0000 (Expect Digit 0)", test_num);
        A = 4'b0000;
        #1;

        check_outputs(1'b0, 7'b0111111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 4'b0001 (Expect Digit 1)", test_num);
        A = 4'b0001;
        #1;

        check_outputs(1'b0, 7'b0000110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 4'b0100 (Expect Digit 1)", test_num);
        A = 4'b0100;
        #1;

        check_outputs(1'b0, 7'b0000110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 4'b1111 (Expect Digit 1)", test_num);
        A = 4'b1111;
        #1;

        check_outputs(1'b0, 7'b0000110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 4'b1010 (Expect Digit 1)", test_num);
        A = 4'b1010;
        #1;

        check_outputs(1'b0, 7'b0000110);
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
        input expected_d1;
        input [6:0] expected_segmentos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d1 === (expected_d1 ^ d1 ^ expected_d1) &&
                expected_segmentos === (expected_segmentos ^ segmentos ^ expected_segmentos)) begin
                $display("PASS");
                $display("  Outputs: d1=%b, segmentos=%h",
                         d1, segmentos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d1=%b, segmentos=%h",
                         expected_d1, expected_segmentos);
                $display("  Got:      d1=%b, segmentos=%h",
                         d1, segmentos);
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
