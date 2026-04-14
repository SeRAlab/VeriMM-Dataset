`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUResultW;
    reg MemToRegW;
    reg [31:0] ReadDataW;
    reg RegWriteW1;
    reg [4:0] WriteRegW1;
    wire RegWriteW2;
    wire [31:0] ResultW;
    wire [4:0] WriteRegW2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUResultW(ALUResultW),
        .MemToRegW(MemToRegW),
        .ReadDataW(ReadDataW),
        .RegWriteW1(RegWriteW1),
        .WriteRegW1(WriteRegW1),
        .RegWriteW2(RegWriteW2),
        .ResultW(ResultW),
        .WriteRegW2(WriteRegW2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select ALUResultW (MemToRegW = 0)", test_num);
            ALUResultW = 32'hAAAA_BBBB;
            ReadDataW  = 32'hCCCC_DDDD;
            MemToRegW  = 1'b0;
            RegWriteW1 = 1'b1;
            WriteRegW1 = 5'd10;

            #1;


            check_outputs(1'b1, 32'hAAAA_BBBB, 5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select ReadDataW (MemToRegW = 1)", test_num);
            ALUResultW = 32'h1234_5678;
            ReadDataW  = 32'h8765_4321;
            MemToRegW  = 1'b1;
            RegWriteW1 = 1'b0;
            WriteRegW1 = 5'd31;

            #1;


            check_outputs(1'b0, 32'h8765_4321, 5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs and signals", test_num);
            ALUResultW = 32'h0000_0000;
            ReadDataW  = 32'h0000_0000;
            MemToRegW  = 1'b0;
            RegWriteW1 = 1'b0;
            WriteRegW1 = 5'd0;

            #1;


            check_outputs(1'b0, 32'h0000_0000, 5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values", test_num);
            ALUResultW = 32'hFFFF_FFFF;
            ReadDataW  = 32'hFFFF_FFFF;
            MemToRegW  = 1'b1;
            RegWriteW1 = 1'b1;
            WriteRegW1 = 5'b11111;

            #1;


            check_outputs(1'b1, 32'hFFFF_FFFF, 5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed signals toggle", test_num);
            ALUResultW = 32'h5555_AAAA;
            ReadDataW  = 32'hEEEE_FFFF;
            MemToRegW  = 1'b0;
            RegWriteW1 = 1'b1;
            WriteRegW1 = 5'd15;

            #1;


            check_outputs(1'b1, 32'h5555_AAAA, 5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change data while MemToReg is high", test_num);
            ALUResultW = 32'hCAFE_BABE;
            ReadDataW  = 32'hDEAD_BEEF;
            MemToRegW  = 1'b1;
            RegWriteW1 = 1'b1;
            WriteRegW1 = 5'd2;

            #1;


            check_outputs(1'b1, 32'hDEAD_BEEF, 5'd2);
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
        input expected_RegWriteW2;
        input [31:0] expected_ResultW;
        input [4:0] expected_WriteRegW2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RegWriteW2 === (expected_RegWriteW2 ^ RegWriteW2 ^ expected_RegWriteW2) &&
                expected_ResultW === (expected_ResultW ^ ResultW ^ expected_ResultW) &&
                expected_WriteRegW2 === (expected_WriteRegW2 ^ WriteRegW2 ^ expected_WriteRegW2)) begin
                $display("PASS");
                $display("  Outputs: RegWriteW2=%b, ResultW=%h, WriteRegW2=%h",
                         RegWriteW2, ResultW, WriteRegW2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegWriteW2=%b, ResultW=%h, WriteRegW2=%h",
                         expected_RegWriteW2, expected_ResultW, expected_WriteRegW2);
                $display("  Got:      RegWriteW2=%b, ResultW=%h, WriteRegW2=%h",
                         RegWriteW2, ResultW, WriteRegW2);
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
