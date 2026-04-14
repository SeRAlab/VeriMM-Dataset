`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_a;
    reg [7:0] in_b;
    wire out_carry;
    wire [7:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_a(in_a),
        .in_b(in_b),
        .out_carry(out_carry),
        .out_sum(out_sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Zero Addition", test_num);
        in_a = 8'h00;
        in_b = 8'h00;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Simple Addition (No Carry)", test_num);
        in_a = 8'h10;
        in_b = 8'h25;
        #1;

        check_outputs(1'b0, 8'h35);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Boundary Case (Sum = 255)", test_num);
        in_a = 8'hFF;
        in_b = 8'h00;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Boundary Case (Sum = 256)", test_num);
        in_a = 8'hFF;
        in_b = 8'h01;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Mid-range Carry", test_num);
        in_a = 8'h80;
        in_b = 8'h80;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Maximum Addition (255 + 255)", test_num);
        in_a = 8'hFF;
        in_b = 8'hFF;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Bit Patterns (Alternating Bits)", test_num);
        in_a = 8'hAA;
        in_b = 8'h55;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: High-bit Addition", test_num);
        in_a = 8'h81;
        in_b = 8'h81;
        #1;

        check_outputs(1'b1, 8'h02);
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
        input expected_out_carry;
        input [7:0] expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_carry === (expected_out_carry ^ out_carry ^ expected_out_carry) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_carry=%b, out_sum=%h",
                         out_carry, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_carry=%b, out_sum=%h",
                         expected_out_carry, expected_out_sum);
                $display("  Got:      out_carry=%b, out_sum=%h",
                         out_carry, out_sum);
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
