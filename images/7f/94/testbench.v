`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num;
    wire [3:0] ones_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .ones_count(ones_count)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            num = 16'h0000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single bit (LSB)");
            num = 16'h0001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single bit (MSB)");
            num = 16'h8000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All ones (Overflow check)");

            num = 16'hFFFF;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 15 ones (Max representable)");
            num = 16'h7FFF;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating bits (0101...)");
            num = 16'h5555;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating bits (1010...)");
            num = 16'hAAAA;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Low nibble full");
            num = 16'h000F;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: High nibble full");
            num = 16'hF000;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Symmetric pattern");

            num = 16'hC3C3;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Sparse pattern");

            num = 16'h1248;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Dense pattern");

            num = 16'hEDB7;
            #1;

            check_outputs(4'd12);
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
        input [3:0] expected_ones_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ones_count === (expected_ones_count ^ ones_count ^ expected_ones_count)) begin
                $display("PASS");
                $display("  Outputs: ones_count=%h",
                         ones_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones_count=%h",
                         expected_ones_count);
                $display("  Got:      ones_count=%h",
                         ones_count);
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
