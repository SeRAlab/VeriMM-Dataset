`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [4:0] EXMEM_Rd;
    reg EXMEM_RegWrite;
    reg [4:0] IDEX_Rs;
    reg [4:0] IDEX_Rt;
    reg [4:0] MEMWB_Rd;
    reg MEMWB_RegWrite;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .EXMEM_Rd(EXMEM_Rd),
        .EXMEM_RegWrite(EXMEM_RegWrite),
        .IDEX_Rs(IDEX_Rs),
        .IDEX_Rt(IDEX_Rt),
        .MEMWB_Rd(MEMWB_Rd),
        .MEMWB_RegWrite(MEMWB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No hazards", test_num);
            IDEX_Rs = 5'd1;
            IDEX_Rt = 5'd2;
            EXMEM_RegWrite = 1'b0;
            EXMEM_Rd = 5'd1;
            MEMWB_RegWrite = 1'b0;
            MEMWB_Rd = 5'd2;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX Hazard on Rs", test_num);
            IDEX_Rs = 5'd10;
            IDEX_Rt = 5'd11;
            EXMEM_RegWrite = 1'b1;
            EXMEM_Rd = 5'd10;
            MEMWB_RegWrite = 1'b0;
            MEMWB_Rd = 5'd0;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX Hazard on Rt", test_num);
            IDEX_Rs = 5'd10;
            IDEX_Rt = 5'd11;
            EXMEM_RegWrite = 1'b1;
            EXMEM_Rd = 5'd11;
            MEMWB_RegWrite = 1'b0;
            MEMWB_Rd = 5'd0;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM Hazard on Rs", test_num);
            IDEX_Rs = 5'd15;
            IDEX_Rt = 5'd16;
            EXMEM_RegWrite = 1'b0;
            EXMEM_Rd = 5'd0;
            MEMWB_RegWrite = 1'b1;
            MEMWB_Rd = 5'd15;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM Hazard on Rt", test_num);
            IDEX_Rs = 5'd15;
            IDEX_Rt = 5'd16;
            EXMEM_RegWrite = 1'b0;
            EXMEM_Rd = 5'd0;
            MEMWB_RegWrite = 1'b1;
            MEMWB_Rd = 5'd16;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Both hazards exist)", test_num);
            IDEX_Rs = 5'd4;
            IDEX_Rt = 5'd4;
            EXMEM_RegWrite = 1'b1;
            EXMEM_Rd = 5'd4;
            MEMWB_RegWrite = 1'b1;
            MEMWB_Rd = 5'd4;
            ALUOp = 2'b00;

            #1;


            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register Zero (No forwarding to $0)", test_num);
            IDEX_Rs = 5'd0;
            IDEX_Rt = 5'd0;
            EXMEM_RegWrite = 1'b1;
            EXMEM_Rd = 5'd0;
            MEMWB_RegWrite = 1'b1;
            MEMWB_Rd = 5'd0;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed stage hazards", test_num);
            IDEX_Rs = 5'd1;
            IDEX_Rt = 5'd2;
            EXMEM_RegWrite = 1'b1;
            EXMEM_Rd = 5'd2;
            MEMWB_RegWrite = 1'b1;
            MEMWB_Rd = 5'd1;
            ALUOp = 2'b00;
            #1;

            check_outputs(2'b01, 2'b10);
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
        input [1:0] expected_ForwardA;
        input [1:0] expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%h, ForwardB=%h",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
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
