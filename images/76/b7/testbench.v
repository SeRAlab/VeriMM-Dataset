`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOp;
    reg [2:0] Funct3;
    reg [6:0] Funct7;
    wire [3:0] ALUcontrolinput;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOp(ALUOp),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUcontrolinput(ALUcontrolinput)
    );
    task testcase001;

        begin
            test_num = 1;
            ALUOp = 2'b00;
            Funct7 = 7'bxxxxxxx;
            Funct3 = 3'bxxx;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ALUOp = 2'b01;
            Funct7 = 7'bxxxxxxx;
            Funct3 = 3'bxxx;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ALUOp = 2'b10;
            Funct7 = 7'b0000000;
            Funct3 = 3'b000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ALUOp = 2'b10;
            Funct7 = 7'b0100000;
            Funct3 = 3'b000;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ALUOp = 2'b10;
            Funct7 = 7'b0000000;
            Funct3 = 3'b111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ALUOp = 2'b10;
            Funct7 = 7'b0000000;
            Funct3 = 3'b110;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ALUOp = 2'b10;
            Funct7 = 7'b0000000;
            Funct3 = 3'b010;
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
        input [3:0] expected_ALUcontrolinput;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUcontrolinput === (expected_ALUcontrolinput ^ ALUcontrolinput ^ expected_ALUcontrolinput)) begin
                $display("PASS");
                $display("  Outputs: ALUcontrolinput=%h",
                         ALUcontrolinput);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUcontrolinput=%h",
                         expected_ALUcontrolinput);
                $display("  Got:      ALUcontrolinput=%h",
                         ALUcontrolinput);
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
