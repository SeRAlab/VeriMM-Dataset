`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 32'h00000000;
            #10;
            $display("Test Case 001: All Zeros");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 32'hFFFFFFFF;
            #10;
            $display("Test Case 002: All Ones");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 32'h00000001;
            #10;
            $display("Test Case 003: Single Bit (LSB)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 32'h80000000;
            #10;
            $display("Test Case 004: Single Bit (MSB)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 32'h12345678;
            #10;
            $display("Test Case 005: Arbitrary Pattern 1");

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 32'hA5A5A5A5;
            #10;
            $display("Test Case 006: Alternating Byte Pattern");


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 32'h11111111;
            #10;
            $display("Test Case 007: Distributed Single Bits");

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 32'hCAFEBABE;
            #10;
            $display("Test Case 008: Hex Word Pattern");

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 32'h0F0F0F0F;
            #10;
            $display("Test Case 009: Byte Nibble Toggle");

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 32'h87654321;
            #10;
            $display("Test Case 010: Reversed Arbitrary Pattern");

            #1;


            check_outputs(1'b1);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
