`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A11;
    reg [7:0] A12;
    reg [7:0] A21;
    reg [7:0] A22;
    wire [7:0] L11;
    wire [7:0] L12;
    wire [7:0] L21;
    wire [7:0] L22;
    wire [7:0] U11;
    wire [7:0] U12;
    wire [7:0] U21;
    wire [7:0] U22;

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
            $display("Test Case %0d: Basic Decomposition (A=[[10, 20], [30, 70]])", test_num);
            A11 = 8'h0A; A12 = 8'h14;
            A21 = 8'h1E; A22 = 8'h46;

            #1;


            check_outputs(8'h01, 8'h00, 8'h03, 8'h01, 8'h0A, 8'h14, 8'h00, 8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Decomposition (A=[[4, 12], [8, 30]])", test_num);
            A11 = 8'h04; A12 = 8'h0C;
            A21 = 8'h08; A22 = 8'h1E;

            #1;


            check_outputs(8'h01, 8'h00, 8'h02, 8'h01, 8'h04, 8'h0C, 8'h00, 8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Values (A=[[1, 5], [2, 12]])", test_num);
            A11 = 8'h01; A12 = 8'h05;
            A21 = 8'h02; A22 = 8'h0C;

            #1;


            check_outputs(8'h01, 8'h00, 8'h02, 8'h01, 8'h01, 8'h05, 8'h00, 8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer Division L21=0 (A=[[15, 30], [5, 20]])", test_num);
            A11 = 8'h0F; A12 = 8'h1E;
            A21 = 8'h05; A22 = 8'h14;

            #1;


            check_outputs(8'h01, 8'h00, 8'h00, 8'h01, 8'h0F, 8'h1E, 8'h00, 8'h14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow/Negative Result (A=[[2, 10], [4, 5]])", test_num);
            A11 = 8'h02; A12 = 8'h0A;
            A21 = 8'h04; A22 = 8'h05;

            #1;


            check_outputs(8'h01, 8'h00, 8'h02, 8'h01, 8'h02, 8'h0A, 8'h00, 8'hF1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            A11 = 8'h01; A12 = 8'h00;
            A21 = 8'h00; A22 = 8'h01;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00, 8'h01, 8'h01, 8'h00, 8'h00, 8'h01);
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
        input [7:0] expected_L11;
        input [7:0] expected_L12;
        input [7:0] expected_L21;
        input [7:0] expected_L22;
        input [7:0] expected_U11;
        input [7:0] expected_U12;
        input [7:0] expected_U21;
        input [7:0] expected_U22;
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
