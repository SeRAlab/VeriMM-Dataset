`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg [5:0] y;
    wire Y3;
    wire Y5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .Y3(Y3),
        .Y5(Y5)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 0; y = 6'b000010;
        $display("Testcase %0d: Input State B, x=0 -> Expected Next State C (Y3=1, Y5=0)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 0; y = 6'b100000;
        $display("Testcase %0d: Input State F, x=0 -> Expected Next State C (Y3=1, Y5=0)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 0; y = 6'b000100;
        $display("Testcase %0d: Input State C, x=0 -> Expected Next State E (Y3=0, Y5=1)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 0; y = 6'b010000;
        $display("Testcase %0d: Input State E, x=0 -> Expected Next State E (Y3=0, Y5=1)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 1; y = 6'b000010;
        $display("Testcase %0d: Input State B, x=1 -> Expected Next State D (Y3=0, Y5=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 1; y = 6'b100000;
        $display("Testcase %0d: Input State F, x=1 -> Expected Next State D (Y3=0, Y5=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 1; y = 6'b000100;
        $display("Testcase %0d: Input State C, x=1 -> Expected Next State D (Y3=0, Y5=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 1; y = 6'b010000;
        $display("Testcase %0d: Input State E, x=1 -> Expected Next State D (Y3=0, Y5=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 0; y = 6'b000001;
        $display("Testcase %0d: Input State A, x=0 -> Expected Next State B (Y3=0, Y5=0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 0; y = 6'b001000;
        $display("Testcase %0d: Input State D, x=0 -> Expected Next State F (Y3=0, Y5=0)", test_num);
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
        testcase009();
        testcase010();
        
        
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
        input expected_Y3;
        input expected_Y5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_Y5 === (expected_Y5 ^ Y5 ^ expected_Y5)) begin
                $display("PASS");
                $display("  Outputs: Y3=%b, Y5=%b",
                         Y3, Y5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y3=%b, Y5=%b",
                         expected_Y3, expected_Y5);
                $display("  Got:      Y3=%b, Y5=%b",
                         Y3, Y5);
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
