`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] funct;
    wire [3:0] out_to_ALU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .funct(funct),
        .out_to_ALU(out_to_ALU)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: ALUOp=00 (Load/Store, should default to ADD)", test_num);
        ALUOp = 2'b00;
        funct = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: ALUOp=01 (BEQ, should default to SUB)", test_num);
        ALUOp = 2'b01;
        funct = 6'bxxxxxx;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: ALUOp=10, Funct=100000 (R-type ADD)", test_num);
        ALUOp = 2'b10;
        funct = 6'b100000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: ALUOp=10, Funct=100010 (R-type SUB)", test_num);
        ALUOp = 2'b10;
        funct = 6'b100010;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: ALUOp=10, Funct=100100 (R-type AND)", test_num);
        ALUOp = 2'b10;
        funct = 6'b100100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: ALUOp=10, Funct=100101 (R-type OR)", test_num);
        ALUOp = 2'b10;
        funct = 6'b100101;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: ALUOp=10, Funct=101010 (R-type SLT)", test_num);
        ALUOp = 2'b10;
        funct = 6'b101010;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: ALUOp=00, Funct=111111 (Don't care funct)", test_num);
        ALUOp = 2'b00;
        funct = 6'b111111;
        #1;

        check_outputs(4'b0010);
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
        input [3:0] expected_out_to_ALU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_to_ALU === (expected_out_to_ALU ^ out_to_ALU ^ expected_out_to_ALU)) begin
                $display("PASS");
                $display("  Outputs: out_to_ALU=%h",
                         out_to_ALU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_to_ALU=%h",
                         expected_out_to_ALU);
                $display("  Got:      out_to_ALU=%h",
                         out_to_ALU);
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
