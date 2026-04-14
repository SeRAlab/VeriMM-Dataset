`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire [2:0] out_not_a;
    wire [2:0] out_not_b;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;
    wire [2:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_not_a(out_not_a),
        .out_not_b(out_not_b),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 3'b000; b = 3'b000;

            #1;


            check_outputs(3'b111, 3'b111, 3'b000, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 3'b111; b = 3'b111;

            #1;


            check_outputs(3'b000, 3'b000, 3'b111, 1'b1, 3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 3'b101; b = 3'b010;

            #1;


            check_outputs(3'b010, 3'b101, 3'b111, 1'b1, 3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 3'b110; b = 3'b011;

            #1;


            check_outputs(3'b001, 3'b100, 3'b111, 1'b1, 3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 3'b001; b = 3'b000;

            #1;


            check_outputs(3'b110, 3'b111, 3'b001, 1'b1, 3'b000);
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
        input [2:0] expected_out_not_a;
        input [2:0] expected_out_not_b;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        input [2:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_not_a === (expected_out_not_a ^ out_not_a ^ expected_out_not_a) &&
                expected_out_not_b === (expected_out_not_b ^ out_not_b ^ expected_out_not_b) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_not_a=%h, out_not_b=%h, out_or_bitwise=%h, out_or_logical=%b, out_xor=%h",
                         out_not_a, out_not_b, out_or_bitwise, out_or_logical, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_not_a=%h, out_not_b=%h, out_or_bitwise=%h, out_or_logical=%b, out_xor=%h",
                         expected_out_not_a, expected_out_not_b, expected_out_or_bitwise, expected_out_or_logical, expected_out_xor);
                $display("  Got:      out_not_a=%h, out_not_b=%h, out_or_bitwise=%h, out_or_logical=%b, out_xor=%h",
                         out_not_a, out_not_b, out_or_bitwise, out_or_logical, out_xor);
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
