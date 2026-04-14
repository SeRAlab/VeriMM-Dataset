`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_hi;
    reg [7:0] in_lo;
    wire [16:0] out;
    wire parity_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_hi(in_hi),
        .in_lo(in_lo),
        .out(out),
        .parity_bit(parity_bit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in_hi = 8'h00;
            in_lo = 8'h00;

            #1;


            check_outputs(17'h00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in_hi = 8'hFF;
            in_lo = 8'hFF;

            #1;


            check_outputs(17'h1FFFE, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Set (LSB)", test_num);
            in_hi = 8'h00;
            in_lo = 8'h01;

            #1;


            check_outputs(17'h00003, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Set (MSB)", test_num);
            in_hi = 8'h80;
            in_lo = 8'h00;

            #1;


            check_outputs(17'h10001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Even Set Bits (Pattern AA55)", test_num);
            in_hi = 8'hAA;
            in_lo = 8'h55;

            #1;


            check_outputs(17'h154AA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd Set Bits (Pattern 1234)", test_num);
            in_hi = 8'h12;
            in_lo = 8'h34;


            #1;



            check_outputs(17'h02469, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            in_hi = 8'h5A;
            in_lo = 8'hA5;


            #1;



            check_outputs(17'h0B54A, 1'b0);
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
        input [16:0] expected_out;
        input expected_parity_bit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_parity_bit === (expected_parity_bit ^ parity_bit ^ expected_parity_bit)) begin
                $display("PASS");
                $display("  Outputs: out=%h, parity_bit=%b",
                         out, parity_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, parity_bit=%b",
                         expected_out, expected_parity_bit);
                $display("  Got:      out=%h, parity_bit=%b",
                         out, parity_bit);
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
