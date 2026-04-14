`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A11;
    reg [7:0] A12;
    reg [7:0] A21;
    reg [7:0] A22;
    reg [7:0] B11;
    reg [7:0] B12;
    reg [7:0] B21;
    reg [7:0] B22;
    wire [15:0] C11;
    wire [15:0] C12;
    wire [15:0] C21;
    wire [15:0] C22;

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
            test_num = test_num + 1;
            $display("Test Case 001: Identity Matrix A * Matrix B");

            A11 = 8'd1; A12 = 8'd0;
            A21 = 8'd0; A22 = 8'd1;

            B11 = 8'd10; B12 = 8'd20;
            B21 = 8'd30; B22 = 8'd40;

            #1;


            check_outputs(16'd10, 16'd20, 16'd30, 16'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Matrix A * Identity Matrix B");

            A11 = 8'd5; A12 = 8'd6;
            A21 = 8'd7; A22 = 8'd8;

            B11 = 8'd1; B12 = 8'd0;
            B21 = 8'd0; B22 = 8'd1;

            #1;


            check_outputs(16'd5, 16'd6, 16'd7, 16'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Multiplication by Zero Matrix");
            A11 = 8'd255; A12 = 8'd255;
            A21 = 8'd255; A22 = 8'd255;
            B11 = 8'd0;   B12 = 8'd0;
            B21 = 8'd0;   B22 = 8'd0;
            #1;

            check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Small Integer Values");

            A11 = 8'd2; A12 = 8'd3;
            A21 = 8'd4; A22 = 8'd5;

            B11 = 8'd6; B12 = 8'd7;
            B21 = 8'd8; B22 = 8'd9;




            #1;





            check_outputs(16'd36, 16'd41, 16'd64, 16'd73);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Large Values (Within 16-bit range)");

            A11 = 8'd100; A12 = 8'd50;
            A21 = 8'd20;  A22 = 8'd200;

            B11 = 8'd30;  B12 = 8'd150;
            B21 = 8'd80;  B22 = 8'd10;




            #1;





            check_outputs(16'd7000, 16'd15500, 16'd16600, 16'd5000);
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
        input [15:0] expected_C11;
        input [15:0] expected_C12;
        input [15:0] expected_C21;
        input [15:0] expected_C22;
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
