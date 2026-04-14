`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Jump;
    reg [25:0] JumpImm;
    reg [1:0] PC_sel;
    reg [15:0] beq_imm;
    reg beq_zero;
    reg [31:0] oldPC;
    reg [31:0] rs;
    wire [31:0] newPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Jump(Jump),
        .JumpImm(JumpImm),
        .PC_sel(PC_sel),
        .beq_imm(beq_imm),
        .beq_zero(beq_zero),
        .oldPC(oldPC),
        .rs(rs),
        .newPC(newPC)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Sequential PC+4", test_num);
            oldPC = 32'h0000_1000;
            PC_sel = 2'b00;
            Jump = 2'b00;
            beq_imm = 16'h0000;
            beq_zero = 0;
            rs = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Branch Not Taken", test_num);
            oldPC = 32'h0000_1000;
            PC_sel = 2'b01;
            beq_zero = 0;
            beq_imm = 16'h0005;
            Jump = 2'b00;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Branch Taken (Forward)", test_num);
            oldPC = 32'h0000_1000;
            PC_sel = 2'b01;
            beq_zero = 1;
            beq_imm = 16'h0002;
            Jump = 2'b00;

            #1;


            check_outputs(32'h0000_100C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Branch Taken (Backward/Sign-Ext)", test_num);
            oldPC = 32'h0000_1008;
            PC_sel = 2'b01;
            beq_zero = 1;
            beq_imm = 16'hFFFF;
            Jump = 2'b00;

            #1;


            check_outputs(32'h0000_1008);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Jump J-Type", test_num);
            oldPC = 32'h1000_0000;
            PC_sel = 2'b10;
            Jump = 2'b01;
            JumpImm = 26'h004_0000;


            #1;



            check_outputs(32'h1010_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Jump Register (JR)", test_num);
            oldPC = 32'h0000_1000;
            PC_sel = 2'b10;
            Jump = 2'b10;
            rs = 32'hABCD_1234;
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Sequential PC+4 (Boundary)", test_num);
            oldPC = 32'hFFFFFFFC;
            PC_sel = 2'b00;
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_newPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_newPC === (expected_newPC ^ newPC ^ expected_newPC)) begin
                $display("PASS");
                $display("  Outputs: newPC=%h",
                         newPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newPC=%h",
                         expected_newPC);
                $display("  Got:      newPC=%h",
                         newPC);
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
