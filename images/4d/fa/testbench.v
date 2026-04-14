`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire a_eq_b;
    wire a_gt_b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .a_eq_b(a_eq_b),
        .a_gt_b(a_gt_b),
        .a_lt_b(a_lt_b)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Equality");
            a = 8'd0;   b = 8'd0;   #1;
   check_outputs(1, 0, 0);
            a = 8'd127; b = 8'd127; #1;
 check_outputs(1, 0, 0);
            a = 8'd255; b = 8'd255; #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: A > B");
            a = 8'd1;   b = 8'd0;   #1;
   check_outputs(0, 1, 0);
            a = 8'd255; b = 8'd254; #1;
 check_outputs(0, 1, 0);
            a = 8'd128; b = 8'd127; #1;
 check_outputs(0, 1, 0);
            a = 8'd200; b = 8'd100; #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: A < B");
            a = 8'd0;   b = 8'd1;   #1;
   check_outputs(0, 0, 1);
            a = 8'd254; b = 8'd255; #1;
 check_outputs(0, 0, 1);
            a = 8'd127; b = 8'd128; #1;
 check_outputs(0, 0, 1);
            a = 8'd100; b = 8'd200; #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: MSB Dominance");

            a = 8'b10000000; b = 8'b01111111; #1;
 check_outputs(0, 1, 0);

            a = 8'b01111111; b = 8'b10000000; #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: LSB Difference");
            a = 8'b11111111; b = 8'b11111110; #1;
 check_outputs(0, 1, 0);
            a = 8'b11111110; b = 8'b11111111; #1;
 check_outputs(0, 0, 1);
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
        input expected_a_eq_b;
        input expected_a_gt_b;
        input expected_a_lt_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_eq_b === (expected_a_eq_b ^ a_eq_b ^ expected_a_eq_b) &&
                expected_a_gt_b === (expected_a_gt_b ^ a_gt_b ^ expected_a_gt_b) &&
                expected_a_lt_b === (expected_a_lt_b ^ a_lt_b ^ expected_a_lt_b)) begin
                $display("PASS");
                $display("  Outputs: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         expected_a_eq_b, expected_a_gt_b, expected_a_lt_b);
                $display("  Got:      a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
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
