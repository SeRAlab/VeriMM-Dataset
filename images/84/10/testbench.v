`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] alu_op;
    reg clk;
    reg [5:0] func;
    wire [2:0] ALU_operation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .clk(clk),
        .func(func),
        .ALU_operation(ALU_operation)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: LW/SW Operation (alu_op=00)", test_num);
        alu_op = 2'b00;
        func = 6'bxxxxxx;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: BEQ Operation (alu_op=01)", test_num);
        alu_op = 2'b01;
        func = 6'bxxxxxx;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: R-type ADD (alu_op=10, func=0x20)", test_num);
        alu_op = 2'b10;
        func = 6'h20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: R-type SUB (alu_op=10, func=0x22)", test_num);
        alu_op = 2'b10;
        func = 6'h22;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: R-type AND (alu_op=10, func=0x24)", test_num);
        alu_op = 2'b10;
        func = 6'h24;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: R-type OR (alu_op=10, func=0x25)", test_num);
        alu_op = 2'b10;
        func = 6'h25;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: R-type SLT (alu_op=10, func=0x2a)", test_num);
        alu_op = 2'b10;
        func = 6'h2a;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_ALU_operation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_operation === (expected_ALU_operation ^ ALU_operation ^ expected_ALU_operation)) begin
                $display("PASS");
                $display("  Outputs: ALU_operation=%h",
                         ALU_operation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_operation=%h",
                         expected_ALU_operation);
                $display("  Got:      ALU_operation=%h",
                         ALU_operation);
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
