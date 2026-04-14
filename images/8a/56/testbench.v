`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EXTOp;
    reg [15:0] imm;
    wire [31:0] Ext_imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTOp(EXTOp),
        .imm(imm),
        .Ext_imm(Ext_imm)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=00 (Sign Extension) - Positive Input", test_num);
        EXTOp = 2'b00;
        imm = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=00 (Sign Extension) - Negative Input", test_num);
        EXTOp = 2'b00;
        imm = 16'h8ABC;
        #1;

        check_outputs(32'hFFFF8ABC);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=01 (Zero Extension)", test_num);
        EXTOp = 2'b01;
        imm = 16'h8001;
        #1;

        check_outputs(32'h00008001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=10 (Lower Half Position)", test_num);
        EXTOp = 2'b10;
        imm = 16'hFFFF;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=11 (Sign Ext + Shift L2) - Positive", test_num);
        EXTOp = 2'b11;
        imm = 16'h0007;
        #1;

        check_outputs(32'h0000001C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=11 (Sign Ext + Shift L2) - Negative", test_num);
        EXTOp = 2'b11;
        imm = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFC);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EXTOp=11 (Sign Ext + Shift L2) - Boundary", test_num);
        EXTOp = 2'b11;
        imm = 16'h8000;
        #1;

        check_outputs(32'hFFFE0000);
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
        input [31:0] expected_Ext_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Ext_imm === (expected_Ext_imm ^ Ext_imm ^ expected_Ext_imm)) begin
                $display("PASS");
                $display("  Outputs: Ext_imm=%h",
                         Ext_imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ext_imm=%h",
                         expected_Ext_imm);
                $display("  Got:      Ext_imm=%h",
                         Ext_imm);
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
