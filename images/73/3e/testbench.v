`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] ctl;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctl(ctl),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (Basic)");
            ctl = 4'b0010; a = 32'd10; b = 32'd20;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition (Overflow/Wrap)");
            ctl = 4'b0010; a = 32'hFFFF_FFFF; b = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Subtraction (Positive Result)");
            ctl = 4'b0110; a = 32'd100; b = 32'd40;
            #1;

            check_outputs(32'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Subtraction (Zero Result & Flag)");
            ctl = 4'b0110; a = 32'hABCDE; b = 32'hABCDE;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise AND");
            ctl = 4'b0000; a = 32'hF0F0_FFFF; b = 32'h0F0F_FFFF;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bitwise OR");
            ctl = 4'b0001; a = 32'hAAAA_0000; b = 32'h0000_5555;
            #1;

            check_outputs(32'hAAAA_5555, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Bitwise NOR");
            ctl = 4'b1100; a = 32'h0000_0000; b = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: SLT (Set on Less Than - True)");
            ctl = 4'b0111; a = 32'd5; b = 32'd10;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: SLT (Set on Less Than - False)");
            ctl = 4'b0111; a = 32'd10; b = 32'd5;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: SLT (Signed Negative Comparison)");

            ctl = 4'b0111; a = 32'hFFFF_FFFF; b = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
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
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
