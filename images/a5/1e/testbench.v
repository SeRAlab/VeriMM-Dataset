`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire a_eq_b;
    wire a_gt_b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .a(a),
        .b(b),
        .a_eq_b(a_eq_b),
        .a_gt_b(a_gt_b),
        .a_lt_b(a_lt_b)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: a = 0, b = 0 (Equality Zero)");
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: a = 15, b = 15 (Equality Max)");
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: a = 10, b = 5 (a > b)");
            a = 4'd10;
            b = 4'd5;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: a = 3, b = 8 (a < b)");
            a = 4'd3;
            b = 4'd8;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: a = 8, b = 7 (MSB dominance)");
            a = 4'b1000;
            b = 4'b0111;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: a = 7, b = 8 (MSB dominance)");
            a = 4'b0111;
            b = 4'b1000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: a = 15, b = 0 (Extremes)");
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: a = 0, b = 15 (Extremes)");
            a = 4'd0;
            b = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: a = 5, b = 5 (Mid-range equality)");
            a = 4'd5;
            b = 4'd5;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: a = 1, b = 0 (LSB difference)");
            a = 4'd1;
            b = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator Testbench");
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
