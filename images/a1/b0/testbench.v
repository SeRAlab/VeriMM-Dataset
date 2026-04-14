`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] i_op;
    wire [3:0] o_op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_op(i_op),
        .o_op(o_op)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i_op = 6'b000000;
            $display("Test Case %0d: i_op = %b", test_num, i_op);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i_op = 6'b100011;
            $display("Test Case %0d: i_op = %b (LW pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i_op = 6'b101011;
            $display("Test Case %0d: i_op = %b (SW pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i_op = 6'b000100;
            $display("Test Case %0d: i_op = %b (BEQ pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i_op = 6'b001000;
            $display("Test Case %0d: i_op = %b (ADDI pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i_op = 6'b001100;
            $display("Test Case %0d: i_op = %b (ANDI pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i_op = 6'b001101;
            $display("Test Case %0d: i_op = %b (ORI pattern)", test_num, i_op);

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i_op = 6'b111111;
            $display("Test Case %0d: i_op = %b (Boundary)", test_num, i_op);

            #1;


            check_outputs(4'b1111);
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
        input [3:0] expected_o_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_op === (expected_o_op ^ o_op ^ expected_o_op)) begin
                $display("PASS");
                $display("  Outputs: o_op=%h",
                         o_op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_op=%h",
                         expected_o_op);
                $display("  Got:      o_op=%h",
                         o_op);
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
