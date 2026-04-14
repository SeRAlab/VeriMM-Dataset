`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [2:0] inst1412;
    reg inst30;
    wire [3:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .inst1412(inst1412),
        .inst30(inst30),
        .sel(sel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=00 (Load/Store - Expected ADD)", test_num);
        ALUOp = 2'b00;
        inst1412 = 3'b000;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=01 (Branch - Expected SUB)", test_num);
        ALUOp = 2'b01;
        inst1412 = 3'b000;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=000, inst30=0 (R-type ADD)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b000;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=000, inst30=1 (R-type SUB)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b000;
        inst30 = 1'b1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=111 (R-type AND)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b111;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=110 (R-type OR)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b110;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=100 (R-type XOR)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b100;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=010 (R-type SLT)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b010;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=101, inst30=0 (R-type SRL)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b101;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=101, inst30=1 (R-type SRA)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b101;
        inst30 = 1'b1;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=10, Funct3=001 (R-type SLL)", test_num);
        ALUOp = 2'b10;
        inst1412 = 3'b001;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALUOp=11 (I-type Example - Funct3 AND)", test_num);
        ALUOp = 2'b11;
        inst1412 = 3'b111;
        inst30 = 1'b0;
        #1;

        check_outputs(4'b0111);
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: sel=%h",
                         sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sel=%h",
                         expected_sel);
                $display("  Got:      sel=%h",
                         sel);
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
