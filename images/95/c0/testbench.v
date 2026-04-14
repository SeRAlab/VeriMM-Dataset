`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] FUNC;
    wire [2:0] OP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .FUNC(FUNC),
        .OP(OP)
    );
    task testcase001;

    begin
        test_num = 1;
        ALUOp = 2'b00;
        FUNC = 6'bXXXXXX;
        #10;
        $display("Testcase %03d: Load/Store (ALUOp=00)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALUOp = 2'b01;
        FUNC = 6'bXXXXXX;
        #10;
        $display("Testcase %03d: BEQ (ALUOp=01)", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALUOp = 2'b10;
        FUNC = 6'b100000;
        #10;
        $display("Testcase %03d: R-type ADD (ALUOp=10, FUNC=100000)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALUOp = 2'b10;
        FUNC = 6'b100010;
        #10;
        $display("Testcase %03d: R-type SUB (ALUOp=10, FUNC=100010)", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUOp = 2'b10;
        FUNC = 6'b100101;
        #10;
        $display("Testcase %03d: R-type OR (ALUOp=10, FUNC=100101)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUOp = 2'b10;
        FUNC = 6'b100111;
        #10;
        $display("Testcase %03d: R-type NOR (ALUOp=10, FUNC=100111)", test_num);
        #1;

        check_outputs(3'b011);
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
        input [2:0] expected_OP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OP === (expected_OP ^ OP ^ expected_OP)) begin
                $display("PASS");
                $display("  Outputs: OP=%h",
                         OP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OP=%h",
                         expected_OP);
                $display("  Got:      OP=%h",
                         OP);
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
