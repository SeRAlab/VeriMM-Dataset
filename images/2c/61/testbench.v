`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A11;
    reg [3:0] A12;
    reg [3:0] A21;
    reg [3:0] A22;
    wire [3:0] L11;
    wire [3:0] L12;
    wire [3:0] L21;
    wire [3:0] L22;
    wire [3:0] U11;
    wire [3:0] U12;
    wire [3:0] U21;
    wire [3:0] U22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22),
        .L11(L11),
        .L12(L12),
        .L21(L21),
        .L22(L22),
        .U11(U11),
        .U12(U12),
        .U21(U21),
        .U22(U22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix", test_num);
            A11 = 4'h1; A12 = 4'h0;
            A21 = 4'h0; A22 = 4'h1;

            #1;


            check_outputs(4'h1, 4'h0, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple 2x2 Decomposition (2,4,4,10)", test_num);
            A11 = 4'd2; A12 = 4'd4;
            A21 = 4'd4; A22 = 4'd10;


            #1;



            check_outputs(4'd1, 4'd0, 4'd2, 4'd1, 4'd2, 4'd4, 4'd0, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exact Integer Division (3,6,3,9)", test_num);
            A11 = 4'd3; A12 = 4'd6;
            A21 = 4'd3; A22 = 4'd9;


            #1;



            check_outputs(4'd1, 4'd0, 4'd1, 4'd1, 4'd3, 4'd6, 4'd0, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unit Values (1,1,1,2)", test_num);
            A11 = 4'd1; A12 = 4'd1;
            A21 = 4'd1; A22 = 4'd2;


            #1;



            check_outputs(4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger Integers (4,4,8,12)", test_num);
            A11 = 4'd4; A12 = 4'd4;
            A21 = 4'd8; A22 = 4'd12;


            #1;



            check_outputs(4'd1, 4'd0, 4'd2, 4'd1, 4'd4, 4'd4, 4'd0, 4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: L21 Truncated to Zero (4,8,2,5)", test_num);
            A11 = 4'd4; A12 = 4'd8;
            A21 = 4'd2; A22 = 4'd5;


            #1;



            check_outputs(4'd1, 4'd0, 4'd0, 4'd1, 4'd4, 4'd8, 4'd0, 4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_L11;
        input [3:0] expected_L12;
        input [3:0] expected_L21;
        input [3:0] expected_L22;
        input [3:0] expected_U11;
        input [3:0] expected_U12;
        input [3:0] expected_U21;
        input [3:0] expected_U22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L11 === (expected_L11 ^ L11 ^ expected_L11) &&
                expected_L12 === (expected_L12 ^ L12 ^ expected_L12) &&
                expected_L21 === (expected_L21 ^ L21 ^ expected_L21) &&
                expected_L22 === (expected_L22 ^ L22 ^ expected_L22) &&
                expected_U11 === (expected_U11 ^ U11 ^ expected_U11) &&
                expected_U12 === (expected_U12 ^ U12 ^ expected_U12) &&
                expected_U21 === (expected_U21 ^ U21 ^ expected_U21) &&
                expected_U22 === (expected_U22 ^ U22 ^ expected_U22)) begin
                $display("PASS");
                $display("  Outputs: L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         L11, L12, L21, L22, U11, U12, U21, U22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         expected_L11, expected_L12, expected_L21, expected_L22, expected_U11, expected_U12, expected_U21, expected_U22);
                $display("  Got:      L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         L11, L12, L21, L22, U11, U12, U21, U22);
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
