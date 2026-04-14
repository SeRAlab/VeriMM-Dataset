`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] signals;
    wire ALUsrc;
    wire Branch;
    wire Jump;
    wire MemRead;
    wire MemToReg;
    wire MemWrite;
    wire RegDst;
    wire RegWrite;
    wire [1:0] size_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signals(signals),
        .ALUsrc(ALUsrc),
        .Branch(Branch),
        .Jump(Jump),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .size_in(size_in)
    );
    task testcase001;

        begin
            test_num = 1;
            signals = 10'b0000000000;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            signals = 10'b1111111111;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            signals = 10'b1000000000;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 1, 0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            signals = 10'b0100000000;

            #1;


            check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            signals = 10'b0010000000;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            signals = 10'b0001110000;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1, 0, 0, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            signals = 10'b0000001100;

            #1;


            check_outputs(0, 1, 1, 0, 0, 0, 0, 0, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            signals = 10'b0000000010;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            signals = 10'b1010101010;


            #1;



            check_outputs(0, 1, 0, 0, 0, 1, 1, 1, 2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            signals = 10'b0101010101;


            #1;



            check_outputs(1, 0, 1, 1, 1, 0, 0, 0, 2'b01);
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
        input expected_ALUsrc;
        input expected_Branch;
        input expected_Jump;
        input expected_MemRead;
        input expected_MemToReg;
        input expected_MemWrite;
        input expected_RegDst;
        input expected_RegWrite;
        input [1:0] expected_size_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUsrc === (expected_ALUsrc ^ ALUsrc ^ expected_ALUsrc) &&
                expected_Branch === (expected_Branch ^ Branch ^ expected_Branch) &&
                expected_Jump === (expected_Jump ^ Jump ^ expected_Jump) &&
                expected_MemRead === (expected_MemRead ^ MemRead ^ expected_MemRead) &&
                expected_MemToReg === (expected_MemToReg ^ MemToReg ^ expected_MemToReg) &&
                expected_MemWrite === (expected_MemWrite ^ MemWrite ^ expected_MemWrite) &&
                expected_RegDst === (expected_RegDst ^ RegDst ^ expected_RegDst) &&
                expected_RegWrite === (expected_RegWrite ^ RegWrite ^ expected_RegWrite) &&
                expected_size_in === (expected_size_in ^ size_in ^ expected_size_in)) begin
                $display("PASS");
                $display("  Outputs: ALUsrc=%b, Branch=%b, Jump=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, size_in=%h",
                         ALUsrc, Branch, Jump, MemRead, MemToReg, MemWrite, RegDst, RegWrite, size_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUsrc=%b, Branch=%b, Jump=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, size_in=%h",
                         expected_ALUsrc, expected_Branch, expected_Jump, expected_MemRead, expected_MemToReg, expected_MemWrite, expected_RegDst, expected_RegWrite, expected_size_in);
                $display("  Got:      ALUsrc=%b, Branch=%b, Jump=%b, MemRead=%b, MemToReg=%b, MemWrite=%b, RegDst=%b, RegWrite=%b, size_in=%h",
                         ALUsrc, Branch, Jump, MemRead, MemToReg, MemWrite, RegDst, RegWrite, size_in);
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
