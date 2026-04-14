`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_a;
    reg [7:0] input_b;
    wire overflow;
    wire [7:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .input_b(input_b),
        .overflow(overflow),
        .sum_out(sum_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero addition", test_num);
        input_a = 8'd0;
        input_b = 8'd0;
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple addition without overflow", test_num);
        input_a = 8'd42;
        input_b = 8'd58;
        #1;

        check_outputs(1'b0, 8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum sum without overflow (255)", test_num);
        input_a = 8'd200;
        input_b = 8'd55;
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Minimum overflow (256 results in 0)", test_num);
        input_a = 8'd255;
        input_b = 8'd1;
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mid-range overflow (128 + 128)", test_num);
        input_a = 8'd128;
        input_b = 8'd128;
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: High value overflow", test_num);
        input_a = 8'd200;
        input_b = 8'd100;
        #1;

        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum possible sum overflow (255 + 255)", test_num);
        input_a = 8'd255;
        input_b = 8'd255;
        #1;

        check_outputs(1'b1, 8'd254);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Boundary check - near overflow", test_num);
        input_a = 8'd127;
        input_b = 8'd128;
        #1;

        check_outputs(1'b0, 8'd255);
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
        input expected_overflow;
        input [7:0] expected_sum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum_out=%h",
                         overflow, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum_out=%h",
                         expected_overflow, expected_sum_out);
                $display("  Got:      overflow=%b, sum_out=%h",
                         overflow, sum_out);
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
