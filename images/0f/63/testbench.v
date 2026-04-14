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
            $display("Test Case %0d: Simple decomposition [2, 4; 6, 15]", test_num);

            A11 = 8'd2; A12 = 8'd4;
            A21 = 8'd6; A22 = 8'd15;


            #1;



            check_outputs(8'h01, 8'h00, 8'h03, 8'h01, 8'h02, 8'h04, 8'h00, 8'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decomposition with larger values [5, 10; 20, 55]", test_num);

            A11 = 8'd5; A12 = 8'd10;
            A21 = 8'd20; A22 = 8'd55;


            #1;



            check_outputs(8'h01, 8'h00, 8'h04, 8'h01, 8'h05, 8'h0a, 8'h00, 8'h0f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity matrix [1, 0; 0, 1]", test_num);

            A11 = 8'd1; A12 = 8'd0;
            A21 = 8'd0; A22 = 8'd1;

            #1;


            check_outputs(8'h01, 8'h00, 8'h00, 8'h01, 8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small divisors [1, 5; 2, 12]", test_num);

            A11 = 8'd1; A12 = 8'd5;
            A21 = 8'd2; A22 = 8'd12;


            #1;



            check_outputs(8'h01, 8'h00, 8'h02, 8'h01, 8'h01, 8'h05, 8'h00, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiples [3, 9; 12, 40]", test_num);

            A11 = 8'd3; A12 = 8'd9;
            A21 = 8'd12; A22 = 8'd40;


            #1;



            check_outputs(8'h01, 8'h00, 8'h04, 8'h01, 8'h03, 8'h09, 8'h00, 8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of two scaling [8, 16; 24, 50]", test_num);

            A11 = 8'd8; A12 = 8'd16;
            A21 = 8'd24; A22 = 8'd50;


            #1;



            check_outputs(8'h01, 8'h00, 8'h03, 8'h01, 8'h08, 8'h10, 8'h00, 8'h02);
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
