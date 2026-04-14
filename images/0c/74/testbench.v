`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] L11;
    reg [3:0] L12;
    reg [3:0] L21;
    reg [3:0] L22;
    reg [3:0] U11;
    reg [3:0] U12;
    reg [3:0] U21;
    reg [3:0] U22;
    wire [7:0] A11;
    wire [7:0] A12;
    wire [7:0] A21;
    wire [7:0] A22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .L11(L11),
        .L12(L12),
        .L21(L21),
        .L22(L22),
        .U11(U11),
        .U12(U12),
        .U21(U21),
        .U22(U22),
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Identity Matrices", test_num);

            L11 = 4'd1; L12 = 4'd0; L21 = 4'd0; L22 = 4'd1;
            U11 = 4'd1; U12 = 4'd0; U21 = 4'd0; U22 = 4'd1;

            #1;


            check_outputs(8'd1, 8'd0, 8'd0, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Small Integers LU Product", test_num);

            L11 = 4'd2; L12 = 4'd0; L21 = 4'd1; L22 = 4'd3;
            U11 = 4'd4; U12 = 4'd2; U21 = 4'd0; U22 = 4'd1;




            #1;





            check_outputs(8'd8, 8'd4, 8'd4, 8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Zeros", test_num);
            L11 = 4'd0; L12 = 4'd0; L21 = 4'd0; L22 = 4'd0;
            U11 = 4'd0; U12 = 4'd0; U21 = 4'd0; U22 = 4'd0;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Large Values (No 8-bit Overflow)", test_num);

            L11 = 4'd15; L12 = 4'd0; L21 = 4'd2; L22 = 4'd4;
            U11 = 4'd10; U12 = 4'd5; U21 = 4'd0; U22 = 4'd12;




            #1;





            check_outputs(8'd150, 8'd75, 8'd20, 8'd58);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Complex Reconstruction", test_num);

            L11 = 4'd5;  L12 = 4'd0; L21 = 4'd10; L22 = 4'd2;
            U11 = 4'd8;  U12 = 4'd6; U21 = 4'd0;  U22 = 4'd15;




            #1;





            check_outputs(8'd40, 8'd30, 8'd80, 8'd90);
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
        input [7:0] expected_A11;
        input [7:0] expected_A12;
        input [7:0] expected_A21;
        input [7:0] expected_A22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A11 === (expected_A11 ^ A11 ^ expected_A11) &&
                expected_A12 === (expected_A12 ^ A12 ^ expected_A12) &&
                expected_A21 === (expected_A21 ^ A21 ^ expected_A21) &&
                expected_A22 === (expected_A22 ^ A22 ^ expected_A22)) begin
                $display("PASS");
                $display("  Outputs: A11=%h, A12=%h, A21=%h, A22=%h",
                         A11, A12, A21, A22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A11=%h, A12=%h, A21=%h, A22=%h",
                         expected_A11, expected_A12, expected_A21, expected_A22);
                $display("  Got:      A11=%h, A12=%h, A21=%h, A22=%h",
                         A11, A12, A21, A22);
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
