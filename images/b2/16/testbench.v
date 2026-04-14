`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MEM_regwrite;
    reg [4:0] EX_MEM_writereg;
    reg [4:0] ID_EX_reg1;
    reg [4:0] ID_EX_reg2;
    reg MEM_WB_regwrite;
    reg [4:0] MEM_WB_writereg;
    wire [1:0] ALUselA;
    wire [1:0] ALUselB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_regwrite(EX_MEM_regwrite),
        .EX_MEM_writereg(EX_MEM_writereg),
        .ID_EX_reg1(ID_EX_reg1),
        .ID_EX_reg2(ID_EX_reg2),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .MEM_WB_writereg(MEM_WB_writereg),
        .ALUselA(ALUselA),
        .ALUselB(ALUselB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - Normal Operation", test_num);

            EX_MEM_regwrite = 0;
            MEM_WB_regwrite = 0;
            ID_EX_reg1 = 5'd1;
            ID_EX_reg2 = 5'd2;
            EX_MEM_writereg = 5'd10;
            MEM_WB_writereg = 5'd11;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: EX Hazard on Reg1", test_num);
            EX_MEM_regwrite = 1;
            MEM_WB_regwrite = 0;
            ID_EX_reg1 = 5'd5;
            ID_EX_reg2 = 5'd6;
            EX_MEM_writereg = 5'd5;
            MEM_WB_writereg = 5'd0;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: EX Hazard on Reg2", test_num);
            EX_MEM_regwrite = 1;
            MEM_WB_regwrite = 0;
            ID_EX_reg1 = 5'd10;
            ID_EX_reg2 = 5'd12;
            EX_MEM_writereg = 5'd12;
            MEM_WB_writereg = 5'd0;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Hazard on Reg1", test_num);
            EX_MEM_regwrite = 0;
            MEM_WB_regwrite = 1;
            ID_EX_reg1 = 5'd20;
            ID_EX_reg2 = 5'd21;
            EX_MEM_writereg = 5'd0;
            MEM_WB_writereg = 5'd20;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Hazard on Reg2", test_num);
            EX_MEM_regwrite = 0;
            MEM_WB_regwrite = 1;
            ID_EX_reg1 = 5'd1;
            ID_EX_reg2 = 5'd2;
            EX_MEM_writereg = 5'd0;
            MEM_WB_writereg = 5'd2;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Register 0 Check (No Forwarding for $zero)", test_num);

            EX_MEM_regwrite = 1;
            MEM_WB_regwrite = 1;
            ID_EX_reg1 = 5'd0;
            ID_EX_reg2 = 5'd0;
            EX_MEM_writereg = 5'd0;
            MEM_WB_writereg = 5'd0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: EX/MEM Priority Check (Overlapping Hazards)", test_num);

            EX_MEM_regwrite = 1;
            MEM_WB_regwrite = 1;
            ID_EX_reg1 = 5'd15;
            ID_EX_reg2 = 5'd31;
            EX_MEM_writereg = 5'd15;
            MEM_WB_writereg = 5'd15;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous EX and MEM hazards (Different Regs)", test_num);
            EX_MEM_regwrite = 1;
            MEM_WB_regwrite = 1;
            ID_EX_reg1 = 5'd7;
            ID_EX_reg2 = 5'd8;
            EX_MEM_writereg = 5'd7;
            MEM_WB_writereg = 5'd8;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: regwrite Signal Validation", test_num);

            EX_MEM_regwrite = 0;
            MEM_WB_regwrite = 0;
            ID_EX_reg1 = 5'd4;
            ID_EX_reg2 = 5'd4;
            EX_MEM_writereg = 5'd4;
            MEM_WB_writereg = 5'd4;
            #1;

            check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_ALUselA;
        input [1:0] expected_ALUselB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUselA === (expected_ALUselA ^ ALUselA ^ expected_ALUselA) &&
                expected_ALUselB === (expected_ALUselB ^ ALUselB ^ expected_ALUselB)) begin
                $display("PASS");
                $display("  Outputs: ALUselA=%h, ALUselB=%h",
                         ALUselA, ALUselB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUselA=%h, ALUselB=%h",
                         expected_ALUselA, expected_ALUselB);
                $display("  Got:      ALUselA=%h, ALUselB=%h",
                         ALUselA, ALUselB);
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
