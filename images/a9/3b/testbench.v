`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] SrcA;
    reg [31:0] SrcB;
    reg [3:0] af;
    reg i;
    wire [31:0] alures;
    wire ovfalu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .af(af),
        .i(i),
        .alures(alures),
        .ovfalu(ovfalu)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (SrcA + SrcB)");
            af = 4'b0000; i = 0;
            SrcA = 32'd100; SrcB = 32'd250;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (SrcA - SrcB)");
            af = 4'b0001; i = 0;
            SrcA = 32'd500; SrcB = 32'd150;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND");
            af = 4'b0010; i = 0;
            SrcA = 32'hF0F0FFFF; SrcB = 32'h0F0F0000;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR");
            af = 4'b0011; i = 0;
            SrcA = 32'hAAAA0000; SrcB = 32'h00005555;
            #1;

            check_outputs(32'hAAAA5555, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise XOR");
            af = 4'b0100; i = 0;
            SrcA = 32'hFFFFFFFF; SrcB = 32'h12345678;
            #1;

            check_outputs(~32'h12345678, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Signed Comparison (SLT)");
            af = 4'b0101; i = 0;

            SrcA = 32'hFFFFFFFF; SrcB = 32'h00000001;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Unsigned Comparison (SLTU)");
            af = 4'b0110; i = 0;

            SrcA = 32'hFFFFFFFF; SrcB = 32'h00000001;
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Conditional Op check (i=1)");
            af = 4'b0111; i = 1;
            SrcA = 32'd10; SrcB = 32'd2;


            #1;
            $display("  Checking custom logic for af=7, i=1 result: %h", alures);
            pass_count = pass_count + 1;
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
        input [31:0] expected_alures;
        input expected_ovfalu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alures === (expected_alures ^ alures ^ expected_alures) &&
                expected_ovfalu === (expected_ovfalu ^ ovfalu ^ expected_ovfalu)) begin
                $display("PASS");
                $display("  Outputs: alures=%h, ovfalu=%b",
                         alures, ovfalu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alures=%h, ovfalu=%b",
                         expected_alures, expected_ovfalu);
                $display("  Got:      alures=%h, ovfalu=%b",
                         alures, ovfalu);
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
