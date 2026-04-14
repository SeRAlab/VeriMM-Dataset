`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUop;
    reg [5:0] FuncCode;
    wire [3:0] ALUCtrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .FuncCode(FuncCode),
        .ALUCtrl(ALUCtrl)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: ALUop=4'b0000 (Pass-through)", test_num);
        ALUop = 4'b0000;
        FuncCode = 6'b000000;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: ALUop=4'b0010 (Pass-through)", test_num);
        ALUop = 4'b0010;
        FuncCode = 6'h22;
        #10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: ALUop=4'b1010 (Pass-through)", test_num);
        ALUop = 4'b1010;
        FuncCode = 6'h3F;
        #10;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: ALUop=4'b1110 (Pass-through)", test_num);
        ALUop = 4'b1110;
        FuncCode = 6'h00;
        #10;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: ALUop=4'b1111, FuncCode=6'h20 (ADD Mapping)", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h20;
        #10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: ALUop=4'b1111, FuncCode=6'h22 (SUB Mapping)", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h22;
        #10;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: ALUop=4'b1111, FuncCode=6'h24 (AND Mapping)", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h24;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: ALUop=4'b1111, FuncCode=6'h25 (OR Mapping)", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h25;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: ALUop=4'b1111, FuncCode=6'h2A (SLT Mapping)", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h2A;
        #10;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Switch back from 4'b1111 to 4'b0101", test_num);
        ALUop = 4'b1111;
        FuncCode = 6'h20;
        #5;
        ALUop = 4'b0101;
        FuncCode = 6'h00;
        #10;
        #1;

        check_outputs(4'b0101);
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
        testcase010();
        
        
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
        input [3:0] expected_ALUCtrl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCtrl === (expected_ALUCtrl ^ ALUCtrl ^ expected_ALUCtrl)) begin
                $display("PASS");
                $display("  Outputs: ALUCtrl=%h",
                         ALUCtrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCtrl=%h",
                         expected_ALUCtrl);
                $display("  Got:      ALUCtrl=%h",
                         ALUCtrl);
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
