`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire [2:0] out_and_bitwise;
    wire [2:0] out_nor_bitwise;
    wire [5:0] out_not;
    wire out_xor;
    wire [2:0] out_xor_bitwise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_and_bitwise(out_and_bitwise),
        .out_nor_bitwise(out_nor_bitwise),
        .out_not(out_not),
        .out_xor(out_xor),
        .out_xor_bitwise(out_xor_bitwise)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 3'b000;
            b = 3'b000;

            #1;


            check_outputs(3'b000, 3'b111, 6'b111111, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One-side All-ones", test_num);
            a = 3'b111;
            b = 3'b000;

            #1;


            check_outputs(3'b000, 3'b000, 6'b111000, 1'b1, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            a = 3'b101;
            b = 3'b011;

            #1;


            check_outputs(3'b001, 3'b000, 6'b100010, 1'b1, 3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Inputs", test_num);
            a = 3'b010;
            b = 3'b010;

            #1;


            check_outputs(3'b010, 3'b101, 6'b101101, 1'b0, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Inputs", test_num);
            a = 3'b110;
            b = 3'b001;

            #1;


            check_outputs(3'b000, 3'b000, 6'b110001, 1'b1, 3'b111);
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
        input [2:0] expected_out_and_bitwise;
        input [2:0] expected_out_nor_bitwise;
        input [5:0] expected_out_not;
        input expected_out_xor;
        input [2:0] expected_out_xor_bitwise;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and_bitwise === (expected_out_and_bitwise ^ out_and_bitwise ^ expected_out_and_bitwise) &&
                expected_out_nor_bitwise === (expected_out_nor_bitwise ^ out_nor_bitwise ^ expected_out_nor_bitwise) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_out_xor_bitwise === (expected_out_xor_bitwise ^ out_xor_bitwise ^ expected_out_xor_bitwise)) begin
                $display("PASS");
                $display("  Outputs: out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor=%b, out_xor_bitwise=%h",
                         out_and_bitwise, out_nor_bitwise, out_not, out_xor, out_xor_bitwise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor=%b, out_xor_bitwise=%h",
                         expected_out_and_bitwise, expected_out_nor_bitwise, expected_out_not, expected_out_xor, expected_out_xor_bitwise);
                $display("  Got:      out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor=%b, out_xor_bitwise=%h",
                         out_and_bitwise, out_nor_bitwise, out_not, out_xor, out_xor_bitwise);
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
