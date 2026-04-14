`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instruction;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [15:0] imm;
    wire [5:0] opcode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .Rs(Rs),
        .Rt(Rt),
        .imm(imm),
        .opcode(opcode)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            instruction = 32'h0000_0000;

            #1;


            check_outputs(5'h00, 5'h00, 16'h0000, 6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            instruction = 32'hFFFF_FFFF;




            #1;





            check_outputs(5'h1F, 5'h1F, 16'hFFFF, 6'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Slicing Verification (Pattern 1)", test_num);
            instruction = 32'h1234_5678;





            #1;






            check_outputs(5'h11, 5'h14, 16'h5678, 6'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Slicing Verification (Pattern 2)", test_num);
            instruction = 32'hDEAD_BEEF;





            #1;






            check_outputs(5'h15, 5'h0D, 16'hBEEF, 6'h37);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Alternating Bits (0xAAAA...)", test_num);
            instruction = 32'hAAAA_AAAA;





            #1;






            check_outputs(5'h15, 5'h0A, 16'hAAAA, 6'h2A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Alternating Bits (0x5555...)", test_num);
            instruction = 32'h5555_5555;





            #1;






            check_outputs(5'h0A, 5'h15, 16'h5555, 6'h15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MIPS-style ADDI Instruction", test_num);



            instruction = 32'h2228_FFFB;
            #1;

            check_outputs(5'h11, 5'h08, 16'hFFFB, 6'h08);
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
        input [4:0] expected_Rs;
        input [4:0] expected_Rt;
        input [15:0] expected_imm;
        input [5:0] expected_opcode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rs === (expected_Rs ^ Rs ^ expected_Rs) &&
                expected_Rt === (expected_Rt ^ Rt ^ expected_Rt) &&
                expected_imm === (expected_imm ^ imm ^ expected_imm) &&
                expected_opcode === (expected_opcode ^ opcode ^ expected_opcode)) begin
                $display("PASS");
                $display("  Outputs: Rs=%h, Rt=%h, imm=%h, opcode=%h",
                         Rs, Rt, imm, opcode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rs=%h, Rt=%h, imm=%h, opcode=%h",
                         expected_Rs, expected_Rt, expected_imm, expected_opcode);
                $display("  Got:      Rs=%h, Rt=%h, imm=%h, opcode=%h",
                         Rs, Rt, imm, opcode);
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
