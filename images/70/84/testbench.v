`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] alu_op;
    reg [5:0] instruction_5_0;
    wire [3:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .instruction_5_0(instruction_5_0),
        .alu_out(alu_out)
    );
    task testcase001;

        begin
            test_num = 1;
            alu_op = 2'b00;
            instruction_5_0 = 6'bXXXXXX;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            alu_op = 2'b01;
            instruction_5_0 = 6'bXXXXXX;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            alu_op = 2'b11;
            instruction_5_0 = 6'bXXXXXX;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            alu_op = 2'b10;
            instruction_5_0 = 6'b100000;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            alu_op = 2'b10;
            instruction_5_0 = 6'b100010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            alu_op = 2'b10;
            instruction_5_0 = 6'b100100;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            alu_op = 2'b10;
            instruction_5_0 = 6'b100101;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            alu_op = 2'b10;
            instruction_5_0 = 6'b100111;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            alu_op = 2'b10;
            instruction_5_0 = 6'b101010;
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
        input [3:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
