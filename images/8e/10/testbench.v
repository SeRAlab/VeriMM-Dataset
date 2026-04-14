`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALU_Op;
    reg [4:0] FUNCT;
    wire [2:0] ALU_Ctrl;
    wire [1:0] Flag_Write;
    wire No_Write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Op(ALU_Op),
        .FUNCT(FUNCT),
        .ALU_Ctrl(ALU_Ctrl),
        .Flag_Write(Flag_Write),
        .No_Write(No_Write)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=0 (Default ADD)", test_num);
        ALU_Op = 1'b0;
        FUNCT = 5'b10101;
        #1;

        check_outputs(3'b000, 2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=ADD, S=0", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b0100_0;
        #1;

        check_outputs(3'b000, 2'b00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=ADD, S=1", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b0100_1;
        #1;

        check_outputs(3'b000, 2'b11, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=SUB, S=1", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b0010_1;
        #1;

        check_outputs(3'b001, 2'b11, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=AND, S=1", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b0000_1;
        #1;

        check_outputs(3'b010, 2'b10, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=ORR, S=0", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b1100_0;
        #1;

        check_outputs(3'b011, 2'b00, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=CMP (SUB + No_Write)", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b1010_1;
        #1;

        check_outputs(3'b001, 2'b11, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_Op=1, FUNCT=TST (AND + No_Write)", test_num);
        ALU_Op = 1'b1;
        FUNCT = 5'b1000_1;
        #1;

        check_outputs(3'b010, 2'b10, 1'b1);
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
        input [2:0] expected_ALU_Ctrl;
        input [1:0] expected_Flag_Write;
        input expected_No_Write;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_Ctrl === (expected_ALU_Ctrl ^ ALU_Ctrl ^ expected_ALU_Ctrl) &&
                expected_Flag_Write === (expected_Flag_Write ^ Flag_Write ^ expected_Flag_Write) &&
                expected_No_Write === (expected_No_Write ^ No_Write ^ expected_No_Write)) begin
                $display("PASS");
                $display("  Outputs: ALU_Ctrl=%h, Flag_Write=%h, No_Write=%b",
                         ALU_Ctrl, Flag_Write, No_Write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Ctrl=%h, Flag_Write=%h, No_Write=%b",
                         expected_ALU_Ctrl, expected_Flag_Write, expected_No_Write);
                $display("  Got:      ALU_Ctrl=%h, Flag_Write=%h, No_Write=%b",
                         ALU_Ctrl, Flag_Write, No_Write);
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
