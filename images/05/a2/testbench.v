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
            $display("Testcase %0d: All Zeros", test_num);
            A11 = 8'h00; A12 = 8'h00; A21 = 8'h00; A22 = 8'h00;
            B11 = 8'h00; B12 = 8'h00; B21 = 8'h00; B22 = 8'h00;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix (A * I = A)", test_num);
            A11 = 8'h05; A12 = 8'h0A; A21 = 8'h0F; A22 = 8'h14;
            B11 = 8'h01; B12 = 8'h00; B21 = 8'h00; B22 = 8'h01;
            #1;

            check_outputs(16'h0005, 16'h000A, 16'h000F, 16'h0014);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Integers (1,2,3,4) * (5,6,7,8)", test_num);




            A11 = 8'd1; A12 = 8'd2; A21 = 8'd3; A22 = 8'd4;
            B11 = 8'd5; B12 = 8'd6; B21 = 8'd7; B22 = 8'd8;
            #1;

            check_outputs(16'h0013, 16'h0016, 16'h002B, 16'h0032);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Scalar Multiplication (All elements same)", test_num);


            A11 = 8'd10; A12 = 8'd10; A21 = 8'd10; A22 = 8'd10;
            B11 = 8'd2;  B12 = 8'd2;  B21 = 8'd2;  B22 = 8'd2;
            #1;

            check_outputs(16'h0028, 16'h0028, 16'h0028, 16'h0028);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse Matrices", test_num);


            A11 = 8'hFF; A12 = 8'h00; A21 = 8'h00; A22 = 8'hFF;
            B11 = 8'h02; B12 = 8'h00; B21 = 8'h00; B22 = 8'h02;
            #1;

            check_outputs(16'h01FE, 16'h0000, 16'h0000, 16'h01FE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (Bit Overflow Truncation Check)", test_num);




            A11 = 8'hFF; A12 = 8'hFF; A21 = 8'hFF; A22 = 8'hFF;
            B11 = 8'hFF; B12 = 8'hFF; B21 = 8'hFF; B22 = 8'hFF;
            #1;

            check_outputs(16'hFC02, 16'hFC02, 16'hFC02, 16'hFC02);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Product No Overflow", test_num);





            A11 = 8'h80; A12 = 8'h00; A21 = 8'h80; A22 = 8'h00;
            B11 = 8'h40; B12 = 8'h40; B21 = 8'h00; B22 = 8'h00;
            #1;

            check_outputs(16'h2000, 16'h2000, 16'h2000, 16'h2000);
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
