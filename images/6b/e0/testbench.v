`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] Inst_i;
    wire Branch_o;
    wire [7:0] Control_o;
    wire Jump_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Inst_i(Inst_i),
        .Branch_o(Branch_o),
        .Control_o(Control_o),
        .Jump_o(Jump_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: R-type (ADD) Instruction", test_num);
            Inst_i = 6'b000000;
            #1;

            check_outputs(1'b0, 8'hD0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Load Word (LW) Instruction", test_num);
            Inst_i = 6'b100011;
            #1;

            check_outputs(1'b0, 8'hA3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Store Word (SW) Instruction", test_num);
            Inst_i = 6'b101011;
            #1;

            check_outputs(1'b0, 8'h24, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Branch (BEQ) Instruction", test_num);
            Inst_i = 6'b000100;
            #1;

            check_outputs(1'b1, 8'h08, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Jump (J) Instruction", test_num);
            Inst_i = 6'b000010;
            #1;

            check_outputs(1'b0, 8'h00, 1'b1);
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
        input expected_Branch_o;
        input [7:0] expected_Control_o;
        input expected_Jump_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Branch_o === (expected_Branch_o ^ Branch_o ^ expected_Branch_o) &&
                expected_Control_o === (expected_Control_o ^ Control_o ^ expected_Control_o) &&
                expected_Jump_o === (expected_Jump_o ^ Jump_o ^ expected_Jump_o)) begin
                $display("PASS");
                $display("  Outputs: Branch_o=%b, Control_o=%h, Jump_o=%b",
                         Branch_o, Control_o, Jump_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Branch_o=%b, Control_o=%h, Jump_o=%b",
                         expected_Branch_o, expected_Control_o, expected_Jump_o);
                $display("  Got:      Branch_o=%b, Control_o=%h, Jump_o=%b",
                         Branch_o, Control_o, Jump_o);
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
