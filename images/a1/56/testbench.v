`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Instruction;
    wire [5:0] Op;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [15:0] imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Instruction(Instruction),
        .Op(Op),
        .Rs(Rs),
        .Rt(Rt),
        .imm(imm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            Instruction = 32'h0000_0000;




            #1;





            check_outputs(6'h00, 5'h00, 5'h00, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            Instruction = 32'hFFFF_FFFF;




            #1;





            check_outputs(6'h3F, 5'h1F, 5'h1F, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ADDI Instruction Example (ADDI $t0, $s1, 100)", test_num);


            Instruction = 32'h2228_0064;
            #1;

            check_outputs(6'h08, 5'h11, 5'h08, 16'h0064);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LW Instruction Example (LW $s0, 4($sp))", test_num);


            Instruction = 32'h8FA4_0004;
            #1;

            check_outputs(6'h23, 5'h1D, 5'h10, 16'h0004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern A", test_num);
            Instruction = 32'hAAAA_AAAA;





            #1;






            check_outputs(6'h2A, 5'h15, 5'h0A, 16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern B", test_num);
            Instruction = 32'h5555_5555;





            #1;






            check_outputs(6'h15, 5'h0A, 5'h15, 16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: BEQ Instruction Example (BEQ $t1, $t2, -8)", test_num);


            Instruction = 32'h112A_FFF8;
            #1;

            check_outputs(6'h04, 5'h09, 5'h0A, 16'hFFF8);
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
        input [5:0] expected_Op;
        input [4:0] expected_Rs;
        input [4:0] expected_Rt;
        input [15:0] expected_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Op === (expected_Op ^ Op ^ expected_Op) &&
                expected_Rs === (expected_Rs ^ Rs ^ expected_Rs) &&
                expected_Rt === (expected_Rt ^ Rt ^ expected_Rt) &&
                expected_imm === (expected_imm ^ imm ^ expected_imm)) begin
                $display("PASS");
                $display("  Outputs: Op=%h, Rs=%h, Rt=%h, imm=%h",
                         Op, Rs, Rt, imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Op=%h, Rs=%h, Rt=%h, imm=%h",
                         expected_Op, expected_Rs, expected_Rt, expected_imm);
                $display("  Got:      Op=%h, Rs=%h, Rt=%h, imm=%h",
                         Op, Rs, Rt, imm);
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
