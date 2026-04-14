`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUOp_i;
    reg [5:0] funct_i;
    wire [3:0] ALUCtrl_o;

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
        test_num = 1;
        ALUOp_i = 4'b0010;
        funct_i = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALUOp_i = 4'b0110;
        funct_i = 6'b000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALUOp_i = 4'b1010;
        funct_i = 6'b100000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALUOp_i = 4'b1010;
        funct_i = 6'b100010;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUOp_i = 4'b1010;
        funct_i = 6'b100100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUOp_i = 4'b1010;
        funct_i = 6'b100101;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ALUOp_i = 4'b1010;
        funct_i = 6'b101010;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ALUOp_i = 4'b1010;
        funct_i = 6'b111111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ALUOp_i = 4'b0000;
        funct_i = 6'b100000;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_ALUCtrl_o;
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
