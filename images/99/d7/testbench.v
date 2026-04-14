`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg extOp;
    reg [15:0] imm16;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extOp(extOp),
        .imm16(imm16),
        .dout(dout)
    );
    task testcase001;

        begin
            extOp = 1'b0;
            imm16 = 16'h0000;
            $display("Test 001: Zero-extension, all zeros");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            extOp = 1'b0;
            imm16 = 16'hFFFF;
            $display("Test 002: Zero-extension, all ones");
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            extOp = 1'b0;
            imm16 = 16'h8001;
            $display("Test 003: Zero-extension, MSB is 1");
            #1;

            check_outputs(32'h00008001);
        end
        endtask

    task testcase004;

        begin
            extOp = 1'b0;
            imm16 = 16'h7ABC;
            $display("Test 004: Zero-extension, arbitrary value");
            #1;

            check_outputs(32'h00007ABC);
        end
        endtask

    task testcase005;

        begin
            extOp = 1'b1;
            imm16 = 16'h0000;
            $display("Test 005: Sign-extension, all zeros");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            extOp = 1'b1;
            imm16 = 16'h7FFF;
            $display("Test 006: Sign-extension, positive max (MSB=0)");
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase007;

        begin
            extOp = 1'b1;
            imm16 = 16'h8000;
            $display("Test 007: Sign-extension, negative min (MSB=1)");
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase008;

        begin
            extOp = 1'b1;
            imm16 = 16'hFFFF;
            $display("Test 008: Sign-extension, all ones (MSB=1)");
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            extOp = 1'b1;
            imm16 = 16'h1234;
            $display("Test 009: Sign-extension, positive value (MSB=0)");
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase010;

        begin
            extOp = 1'b1;
            imm16 = 16'hFEDC;
            $display("Test 010: Sign-extension, negative value (MSB=1)");
            #1;

            check_outputs(32'hFFFFFEDC);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
