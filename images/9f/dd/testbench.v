`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUOp;
    reg bit_25;
    reg bit_30;
    reg [2:0] function3;
    wire [3:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .bit_25(bit_25),
        .bit_30(bit_30),
        .function3(function3),
        .control(control)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 000 (Load/Store - Expect ADD)", test_num);
            ALUOp = 3'b000;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 001 (Branch - Expect SUB)", test_num);
            ALUOp = 3'b001;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b000;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 000, Bit30 0 (R-type ADD)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 000, Bit30 1 (R-type SUB)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b1;
            bit_25 = 1'b0;
            function3 = 3'b000;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 111 (R-type AND)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 110 (R-type OR)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b110;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 100 (R-type XOR)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b100;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 010 (R-type SLT)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b010;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 101, Bit30 0 (R-type SRL)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b101;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Funct3 101, Bit30 1 (R-type SRA)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b1;
            bit_25 = 1'b0;
            function3 = 3'b101;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 110 (I-type Logical check - OR)", test_num);
            ALUOp = 3'b110;
            bit_30 = 1'b0;
            bit_25 = 1'b0;
            function3 = 3'b110;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ALUOp 010, Bit25 1 (M-Extension check - MUL)", test_num);
            ALUOp = 3'b010;
            bit_30 = 1'b0;
            bit_25 = 1'b1;
            function3 = 3'b000;


            #1;



            check_outputs(4'b1000);
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
        input [3:0] expected_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
