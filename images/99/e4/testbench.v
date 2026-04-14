`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Inst;
    reg [31:0] PCPlus4;
    reg [31:0] ResumeAddr;
    reg reset;
    wire [31:0] JmpAddr;
    wire PCSrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Inst(Inst),
        .PCPlus4(PCPlus4),
        .ResumeAddr(ResumeAddr),
        .reset(reset),
        .JmpAddr(JmpAddr),
        .PCSrc(PCSrc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Condition", test_num);
            reset = 1;
            Inst = 32'h08000001;
            PCPlus4 = 32'h10000000;
            ResumeAddr = 32'hABCDE000;
            #10;

            #1;


            check_outputs(32'h00000000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 2 (Jump Target Calculation)", test_num);
            reset = 0;
            PCPlus4 = 32'h10000000;



            Inst = 32'h08000005;
            ResumeAddr = 32'hABCDE000;
            #10;
            #1;

            check_outputs(32'h10000014, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 3 (Resume Address)", test_num);
            reset = 0;
            PCPlus4 = 32'h20000000;

            Inst = 32'h0C000000;
            ResumeAddr = 32'hDEADBEEF;
            #10;

            #1;


            check_outputs(32'hDEADBEEF, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Opcode (Opcode 0)", test_num);
            reset = 0;
            Inst = 32'h00000000;
            PCPlus4 = 32'h10000000;
            ResumeAddr = 32'hABCDE000;
            #10;

            #1;


            check_outputs(32'h00000000, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Opcode (Opcode 4 - BEQ)", test_num);
            reset = 0;
            Inst = 32'h1000FFFF;
            PCPlus4 = 32'h10000000;
            ResumeAddr = 32'hABCDE000;
            #10;
            #1;

            check_outputs(32'h00000000, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 2 with High PC Bits", test_num);
            reset = 0;
            PCPlus4 = 32'hF0000000;


            Inst = 32'h0BFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFC, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 3 with Null Resume Address", test_num);
            reset = 0;
            Inst = 32'h0C00FFFF;
            ResumeAddr = 32'h00000000;
            #10;
            #1;

            check_outputs(32'h00000000, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Jump to Reset", test_num);

            reset = 0;
            Inst = 32'h0800000A;
            PCPlus4 = 32'h40000000;
            #5;

            reset = 1;
            #5;
            #1;

            check_outputs(32'h00000000, 0);
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
        input [31:0] expected_JmpAddr;
        input expected_PCSrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_JmpAddr === (expected_JmpAddr ^ JmpAddr ^ expected_JmpAddr) &&
                expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc)) begin
                $display("PASS");
                $display("  Outputs: JmpAddr=%h, PCSrc=%b",
                         JmpAddr, PCSrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: JmpAddr=%h, PCSrc=%b",
                         expected_JmpAddr, expected_PCSrc);
                $display("  Got:      JmpAddr=%h, PCSrc=%b",
                         JmpAddr, PCSrc);
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
