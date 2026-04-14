`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] b_input;
    reg enable;
    wire [1:0] b_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_input(b_input),
        .enable(enable),
        .b_output(b_output)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enable signal low (Output should be 00)");
            enable = 0;
            b_input = 4'b1111;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 8 (1000), Enable high");
            enable = 1;
            b_input = 4'b1000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 4 (0100), Enable high");
            enable = 1;
            b_input = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 2 (0010), Enable high");
            enable = 1;
            b_input = 4'b0010;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input 1 (0001), Enable high");
            enable = 1;
            b_input = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority Logic - 8 and 4 high (1100)");
            enable = 1;
            b_input = 4'b1100;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority Logic - 4 and 2 high (0110)");
            enable = 1;
            b_input = 4'b0110;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Priority Logic - 2 and 1 high (0011)");
            enable = 1;
            b_input = 4'b0011;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: All inputs high (1111)");
            enable = 1;
            b_input = 4'b1111;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: No inputs high (0000)");
            enable = 1;
            b_input = 4'b0000;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_b_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_output === (expected_b_output ^ b_output ^ expected_b_output)) begin
                $display("PASS");
                $display("  Outputs: b_output=%h",
                         b_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_output=%h",
                         expected_b_output);
                $display("  Got:      b_output=%h",
                         b_output);
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
