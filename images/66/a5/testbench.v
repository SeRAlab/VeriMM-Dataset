`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [3:0] out;

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
            $display("Test Case 001: Input = 0000");
            test_num = 1;
            in = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input = 0001");
            test_num = 2;
            in = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input = 0010");
            test_num = 3;
            in = 4'b0010;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input = 0011");
            test_num = 4;
            in = 4'b0011;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input = 0100");
            test_num = 5;
            in = 4'b0100;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input = 0111");
            test_num = 6;
            in = 4'b0111;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input = 1000");
            test_num = 7;
            in = 4'b1000;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input = 1010");
            test_num = 8;
            in = 4'b1010;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input = 1101");
            test_num = 9;
            in = 4'b1101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input = 1111");
            test_num = 10;
            in = 4'b1111;
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
