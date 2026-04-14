`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] op;
    wire [1:0] alu_op;
    wire [6:0] main_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .alu_op(alu_op),
        .main_control(main_control)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: R-type (op=000000)", test_num);
            op = 6'b000000;

            #1;


            check_outputs(2'b10, 7'b1100000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Word (op=100011)", test_num);
            op = 6'b100011;

            #1;


            check_outputs(2'b00, 7'b1010101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Store Word (op=101011)", test_num);
            op = 6'b101011;

            #1;


            check_outputs(2'b00, 7'b0010010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Branch Equal (op=000100)", test_num);
            op = 6'b000100;

            #1;


            check_outputs(2'b01, 7'b0001000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Add Immediate (op=001000)", test_num);
            op = 6'b001000;

            #1;


            check_outputs(2'b00, 7'b1010000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Invalid Opcode (op=111111)", test_num);
            op = 6'b111111;

            #1;


            check_outputs(2'b00, 7'b0000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Jump Instruction (op=000010)", test_num);
            op = 6'b000010;


            #1;



            check_outputs(2'b00, 7'b0000000);
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
        input [1:0] expected_alu_op;
        input [6:0] expected_main_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_op === (expected_alu_op ^ alu_op ^ expected_alu_op) &&
                expected_main_control === (expected_main_control ^ main_control ^ expected_main_control)) begin
                $display("PASS");
                $display("  Outputs: alu_op=%h, main_control=%h",
                         alu_op, main_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_op=%h, main_control=%h",
                         expected_alu_op, expected_main_control);
                $display("  Got:      alu_op=%h, main_control=%h",
                         alu_op, main_control);
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
