`timescale 1ns/1ps

module binary_divider_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_divider dut (
        .a(a),
        .b(b),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: Max dividend divided by 1");
            a = 4'd15; b = 4'd1;
            #1;

            check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Exact division");
            a = 4'd12; b = 4'd4;
            #1;

            check_outputs(4'd3, 4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Division with remainder");
            a = 4'd13; b = 4'd3;
            #1;

            check_outputs(4'd4, 4'd1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Dividend smaller than divisor");
            a = 4'd3; b = 4'd7;
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Dividend is zero");
            a = 4'd0; b = 4'd5;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Dividend equals divisor");
            a = 4'd9; b = 4'd9;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Max dividend and max divisor");
            a = 4'd15; b = 4'd15;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: Division by 2 (bit shift check)");
            a = 4'd11; b = 4'd2;
            #1;

            check_outputs(4'd5, 4'd1);
        end
        endtask

    task testcase009;

        begin
            $display("\nTest Case 009: Prime division result");
            a = 4'd14; b = 4'd4;
            #1;

            check_outputs(4'd3, 4'd2);
        end
        endtask

    task testcase010;

        begin
            $display("\nTest Case 010: Result of 2 remainder 0");
            a = 4'd10; b = 4'd5;
            #1;

            check_outputs(4'd2, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_divider Testbench");
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
