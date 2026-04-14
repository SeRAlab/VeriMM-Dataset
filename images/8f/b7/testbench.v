`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DI;
    reg FSM_exp_operation_A_S;
    reg [1:0] FSM_selector_B;
    reg [6:0] Q;
    reg [30:0] Q_reg;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DI(DI),
        .FSM_exp_operation_A_S(FSM_exp_operation_A_S),
        .FSM_selector_B(FSM_selector_B),
        .Q(Q),
        .Q_reg(Q_reg),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (10 + 5)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 0;
            Q_reg = 31'd10;
            Q = 7'd5;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with lower nibble wrap (15 + 2)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 0;
            Q_reg = 31'd15;
            Q = 7'd2;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (10 - 4)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 1;
            Q_reg = 31'd10;
            Q = 7'd4;

            #1;


            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with borrow (16 - 1)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 1;
            Q_reg = 31'd16;
            Q = 7'd1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Q_reg Addition", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 0;
            Q_reg = 31'h7FFFFFFF;
            Q = 7'd1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 1;
            Q_reg = 31'd0;
            Q = 7'd1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Q Subtraction (127 - 127)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 1;
            Q_reg = 31'd127;
            Q = 7'd127;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Addition (8 + 8)", test_num);
            DI = 0;
            FSM_selector_B = 2'b00;
            FSM_exp_operation_A_S = 0;
            Q_reg = 31'd8;
            Q = 7'd8;

            #1;


            check_outputs(4'h0);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
