`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [5:0] funct;
    wire [3:0] ALUctl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUctl(ALUctl)
    );
    task testcase001;

    begin
        ALUOp = 2'b00;
        funct = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        ALUOp = 2'b01;
        funct = 6'b000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        ALUOp = 2'b10;
        funct = 6'b100000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        ALUOp = 2'b10;
        funct = 6'b100010;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        ALUOp = 2'b10;
        funct = 6'b100100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        ALUOp = 2'b10;
        funct = 6'b100101;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        ALUOp = 2'b10;
        funct = 6'b101010;
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
        input [3:0] expected_ALUctl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUctl === (expected_ALUctl ^ ALUctl ^ expected_ALUctl)) begin
                $display("PASS");
                $display("  Outputs: ALUctl=%h",
                         ALUctl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUctl=%h",
                         expected_ALUctl);
                $display("  Got:      ALUctl=%h",
                         ALUctl);
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
