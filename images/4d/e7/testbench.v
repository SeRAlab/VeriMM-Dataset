`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out_carry;
    wire [7:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_carry(out_carry),
        .out_sum(out_sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 8'h00;
            b = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Carry", test_num);
            a = 8'h01;
            b = 8'h01;

            #1;


            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Inputs (No Carries)", test_num);
            a = 8'hAA;
            b = 8'h55;

            #1;


            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Ripple Carry", test_num);
            a = 8'hFF;
            b = 8'h01;

            #1;


            check_outputs(8'hFE, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Carry Chain", test_num);
            a = 8'h0F;
            b = 8'h0F;

            #1;


            check_outputs(8'h1E, 8'h1E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Most Significant Bit Addition", test_num);
            a = 8'h80;
            b = 8'h80;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Bits Carry Chain", test_num);
            a = 8'h7F;
            b = 8'h01;

            #1;


            check_outputs(8'hFE, 8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternate High Bits Carry", test_num);
            a = 8'h7F;
            b = 8'h7F;

            #1;


            check_outputs(8'hFE, 8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values", test_num);
            a = 8'hFF;
            b = 8'hFF;

            #1;


            check_outputs(8'hFE, 8'hFE);
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
        input [7:0] expected_out_carry;
        input [7:0] expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_carry === (expected_out_carry ^ out_carry ^ expected_out_carry) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_carry=%h, out_sum=%h",
                         out_carry, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_carry=%h, out_sum=%h",
                         expected_out_carry, expected_out_sum);
                $display("  Got:      out_carry=%h, out_sum=%h",
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
