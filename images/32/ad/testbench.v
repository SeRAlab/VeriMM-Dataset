`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A11;
    reg [3:0] A12;
    reg [3:0] A21;
    reg [3:0] A22;
    reg [3:0] B11;
    reg [3:0] B12;
    reg [3:0] B21;
    reg [3:0] B22;
    wire [7:0] C11;
    wire [7:0] C12;
    wire [7:0] C21;
    wire [7:0] C22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiplier dut (
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22),
        .B11(B11),
        .B12(B12),
        .B21(B21),
        .B22(B22),
        .C11(C11),
        .C12(C12),
        .C21(C21),
        .C22(C22)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros");
        A11 = 4'd0; A12 = 4'd0; A21 = 4'd0; A22 = 4'd0;
        B11 = 4'd0; B12 = 4'd0; B21 = 4'd0; B22 = 4'd0;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Identity Matrix B");
        A11 = 4'd5; A12 = 4'd2; A21 = 4'd3; A22 = 4'd7;
        B11 = 4'd1; B12 = 4'd0; B21 = 4'd0; B22 = 4'd1;

        #1;


        check_outputs(8'd5, 8'd2, 8'd3, 8'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Identity Matrix A");
        A11 = 4'd1; A12 = 4'd0; A21 = 4'd0; A22 = 4'd1;
        B11 = 4'd4; B12 = 4'd8; B21 = 4'd1; B22 = 4'd2;

        #1;


        check_outputs(8'd4, 8'd8, 8'd1, 8'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Standard Multiplication");

        A11 = 4'd1; A12 = 4'd2; A21 = 4'd3; A22 = 4'd4;
        B11 = 4'd5; B12 = 4'd6; B21 = 4'd7; B22 = 4'd8;




        #1;





        check_outputs(8'h13, 8'h16, 8'h2B, 8'h32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Scalar Multiplication (A is 2*I)");
        A11 = 4'd2; A12 = 4'd0; A21 = 4'd0; A22 = 4'd2;
        B11 = 4'd10; B12 = 4'd11; B21 = 4'd12; B22 = 4'd13;

        #1;


        check_outputs(8'd20, 8'd22, 8'd24, 8'd26);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Maximum Values (Truncation Check)");

        A11 = 4'd15; A12 = 4'd15; A21 = 4'd15; A22 = 4'd15;
        B11 = 4'd15; B12 = 4'd15; B21 = 4'd15; B22 = 4'd15;


        #1;



        check_outputs(8'hC2, 8'hC2, 8'hC2, 8'hC2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Mixed Values");
        A11 = 4'd15; A12 = 4'd1; A21 = 4'd0; A22 = 4'd8;
        B11 = 4'd2;  B12 = 4'd4; B21 = 4'd15; B22 = 4'd3;




        #1;





        check_outputs(8'h2D, 8'h3F, 8'h78, 8'h18);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiplier Testbench");
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
        input [7:0] expected_C11;
        input [7:0] expected_C12;
        input [7:0] expected_C21;
        input [7:0] expected_C22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C11 === (expected_C11 ^ C11 ^ expected_C11) &&
                expected_C12 === (expected_C12 ^ C12 ^ expected_C12) &&
                expected_C21 === (expected_C21 ^ C21 ^ expected_C21) &&
                expected_C22 === (expected_C22 ^ C22 ^ expected_C22)) begin
                $display("PASS");
                $display("  Outputs: C11=%h, C12=%h, C21=%h, C22=%h",
                         C11, C12, C21, C22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C11=%h, C12=%h, C21=%h, C22=%h",
                         expected_C11, expected_C12, expected_C21, expected_C22);
                $display("  Got:      C11=%h, C12=%h, C21=%h, C22=%h",
                         C11, C12, C21, C22);
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
