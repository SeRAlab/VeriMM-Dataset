`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] CTRL;
    wire [31:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Addition - Basic");
            A = 32'h0000_0005;
            B = 32'h0000_000A;
            CTRL = 2'b00;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Addition - Overflow");
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            CTRL = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Subtraction - Basic");
            A = 32'h0000_0014;
            B = 32'h0000_0005;
            CTRL = 2'b01;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Subtraction - Negative Result (2's complement)");
            A = 32'h0000_0005;
            B = 32'h0000_000A;
            CTRL = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFB);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Bitwise AND - Basic");
            A = 32'hAAAA_AAAA;
            B = 32'hFFFF_0000;
            CTRL = 2'b10;
            #1;

            check_outputs(32'hAAAA_0000);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Bitwise AND - Zero Result");
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            CTRL = 2'b10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Bitwise OR - Basic");
            A = 32'hF0F0_F0F0;
            B = 32'h0F0F_0F0F;
            CTRL = 2'b11;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Bitwise OR - Zero operand");
            A = 32'h1234_5678;
            B = 32'h0000_0000;
            CTRL = 2'b11;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase009;

        begin
            $display("\nTestcase 009: Addition - Large values");
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            CTRL = 2'b00;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase010;

        begin
            $display("\nTestcase 010: Subtraction - Result Zero");
            A = 32'hDEAD_BEEF;
            B = 32'hDEAD_BEEF;
            CTRL = 2'b01;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [31:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
