`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp_i;
    reg [5:0] funct_i;
    wire [2:0] ALUCtrl_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp_i(ALUOp_i),
        .funct_i(funct_i),
        .ALUCtrl_o(ALUCtrl_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direct Addition (ALUOp=00)", test_num);
            ALUOp_i = 2'b00;
            funct_i = 6'bXXXXXX;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direct Subtraction (ALUOp=01)", test_num);
            ALUOp_i = 2'b01;
            funct_i = 6'bXXXXXX;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type ADD (Funct=0x20)", test_num);
            ALUOp_i = 2'b10;
            funct_i = 6'b100000;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type SUB (Funct=0x22)", test_num);
            ALUOp_i = 2'b10;
            funct_i = 6'b100010;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type AND (Funct=0x24)", test_num);
            ALUOp_i = 2'b10;
            funct_i = 6'b100100;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type OR (Funct=0x25)", test_num);
            ALUOp_i = 2'b10;
            funct_i = 6'b100101;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-type MUL (Funct=0x18)", test_num);
            ALUOp_i = 2'b10;
            funct_i = 6'b011000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Funct check with non-R-type ALUOp", test_num);

            ALUOp_i = 2'b00;
            funct_i = 6'b100010;
            #1;

            check_outputs(3'b010);
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
        input [2:0] expected_ALUCtrl_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUCtrl_o === (expected_ALUCtrl_o ^ ALUCtrl_o ^ expected_ALUCtrl_o)) begin
                $display("PASS");
                $display("  Outputs: ALUCtrl_o=%h",
                         ALUCtrl_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUCtrl_o=%h",
                         expected_ALUCtrl_o);
                $display("  Got:      ALUCtrl_o=%h",
                         ALUCtrl_o);
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
