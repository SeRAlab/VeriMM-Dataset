`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enable low, input high (Priority check skipped)");
            enable = 0;
            in = 8'b11111111;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable high, input bit 7 high");
            enable = 1;
            in = 8'b10000000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable high, input bit 6 high");
            enable = 1;
            in = 8'b01000000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable high, input bit 5 high");
            enable = 1;
            in = 8'b00100000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable high, input bit 4 high");
            enable = 1;
            in = 8'b00010000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable high, input bit 3 high");
            enable = 1;
            in = 8'b00001000;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable high, input bit 2 high");
            enable = 1;
            in = 8'b00000100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable high, input bit 1 high");
            enable = 1;
            in = 8'b00000010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enable high, input bit 0 high");
            enable = 1;
            in = 8'b00000001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enable high, all bits high (Priority bit 7)");
            enable = 1;
            in = 8'b11111111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Enable high, bits 4 to 0 high (Priority bit 4)");
            enable = 1;
            in = 8'b00011111;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Enable high, no bits high");
            enable = 1;
            in = 8'b00000000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Enable low, no bits high");
            enable = 0;
            in = 8'b00000000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase014;

        begin
            $display("Testcase 014: Enable high, non-contiguous bits (7, 5, 2 high)");
            enable = 1;
            in = 8'b10100100;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase015;

        begin
            $display("Testcase 015: Enable high, non-contiguous bits (3, 1 high)");
            enable = 1;
            in = 8'b00001010;
            #1;

            check_outputs(3'd3);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [2:0] expected_out;
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
