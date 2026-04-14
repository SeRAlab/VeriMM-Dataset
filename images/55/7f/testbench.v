`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire out_continuous_zero;
    wire out_equal_halves;
    wire out_most_ones;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_continuous_zero(out_continuous_zero),
        .out_equal_halves(out_equal_halves),
        .out_most_ones(out_most_ones)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 8'b00000000;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 8'b11111111;

        #1;


        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 8'b11110001;

        #1;


        check_outputs(1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 8'b00011111;

        #1;


        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 8'b10111011;

        #1;


        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 8'b11000111;

        #1;


        check_outputs(1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 8'b10010011;

        #1;


        check_outputs(0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 8'b11101100;

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 8'b11111000;

        #1;


        check_outputs(1, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 8'b00010101;

        #1;


        check_outputs(1, 0, 0);
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
        input expected_out_continuous_zero;
        input expected_out_equal_halves;
        input expected_out_most_ones;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_continuous_zero === (expected_out_continuous_zero ^ out_continuous_zero ^ expected_out_continuous_zero) &&
                expected_out_equal_halves === (expected_out_equal_halves ^ out_equal_halves ^ expected_out_equal_halves) &&
                expected_out_most_ones === (expected_out_most_ones ^ out_most_ones ^ expected_out_most_ones)) begin
                $display("PASS");
                $display("  Outputs: out_continuous_zero=%b, out_equal_halves=%b, out_most_ones=%b",
                         out_continuous_zero, out_equal_halves, out_most_ones);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_continuous_zero=%b, out_equal_halves=%b, out_most_ones=%b",
                         expected_out_continuous_zero, expected_out_equal_halves, expected_out_most_ones);
                $display("  Got:      out_continuous_zero=%b, out_equal_halves=%b, out_most_ones=%b",
                         out_continuous_zero, out_equal_halves, out_most_ones);
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
