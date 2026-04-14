`timescale 1ns/1ps

module Adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder_8bit dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            $display("Test Case 001: Zero addition (0 + 0)");
            test_num = test_num + 1;
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Basic addition (10 + 20)");
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd20;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Addition with max single input (255 + 0)");
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Overflow check (255 + 1)");
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Overflow check (128 + 128)");
            test_num = test_num + 1;
            A = 8'd128;
            B = 8'd128;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Max addition overflow (255 + 255)");
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Bit pattern alternating (0xAA + 0x55)");
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Medium overflow (200 + 100)");
            test_num = test_num + 1;
            A = 8'd200;
            B = 8'd100;
            #1;

            check_outputs(8'd44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder_8bit Testbench");
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
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
