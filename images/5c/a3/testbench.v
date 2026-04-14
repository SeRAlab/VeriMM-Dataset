`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] OP1;
    reg [6:0] OP2;
    reg [6:0] OP3;
    reg [6:0] OP4;
    reg [6:0] OP5;
    wire [4:0] aluOp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OP1(OP1),
        .OP2(OP2),
        .OP3(OP3),
        .OP4(OP4),
        .OP5(OP5),
        .aluOp(aluOp)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros (None should be valid)");
            OP1 = 7'd0; OP2 = 7'd0; OP3 = 7'd0; OP4 = 7'd0; OP5 = 7'd0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All in range (All should be valid)");
            OP1 = 7'd5; OP2 = 7'd1; OP3 = 7'd10; OP4 = 7'd7; OP5 = 7'd3;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All at the upper bound limit (11) (None should be valid)");
            OP1 = 7'd11; OP2 = 7'd11; OP3 = 7'd11; OP4 = 7'd11; OP5 = 7'd11;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary check (1 and 10 are valid)");
            OP1 = 7'd1;
            OP2 = 7'd10;
            OP3 = 7'd0;
            OP4 = 7'd11;
            OP5 = 7'd127;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating bits valid/invalid");
            OP1 = 7'd1;
            OP2 = 7'd0;
            OP3 = 7'd5;
            OP4 = 7'd11;
            OP5 = 7'd10;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High values above 11");
            OP1 = 7'd12; OP2 = 7'd15; OP3 = 7'd20; OP4 = 7'd50; OP5 = 7'd100;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single input valid (OP3)");
            OP1 = 7'd0; OP2 = 7'd11; OP3 = 7'd8; OP4 = 7'd12; OP5 = 7'd0;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: All inputs at max 7-bit value (127)");
            OP1 = 7'd127; OP2 = 7'd127; OP3 = 7'd127; OP4 = 7'd127; OP5 = 7'd127;
            #1;

            check_outputs(5'b00000);
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
        input [4:0] expected_aluOp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluOp === (expected_aluOp ^ aluOp ^ expected_aluOp)) begin
                $display("PASS");
                $display("  Outputs: aluOp=%h",
                         aluOp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOp=%h",
                         expected_aluOp);
                $display("  Got:      aluOp=%h",
                         aluOp);
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
