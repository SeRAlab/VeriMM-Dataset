`timescale 1ns/1ps

module matrix_factorization_tb;

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
    matrix_factorization dut (
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
            $display("\nTest Case %0d: Identity Matrix Multiplication", test_num);

            A11 = 4'h3; A12 = 4'h5;
            A21 = 4'h7; A22 = 4'h9;

            B11 = 4'h1; B12 = 4'h0;
            B21 = 4'h0; B22 = 4'h1;


            #1;



            check_outputs(8'h03, 8'h05, 8'h07, 8'h09);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix Multiplication", test_num);

            A11 = 4'hF; A12 = 4'hF;
            A21 = 4'hF; A22 = 4'hF;

            B11 = 4'h0; B12 = 4'h0;
            B21 = 4'h0; B22 = 4'h0;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Values Multiplication", test_num);

            A11 = 4'd1; A12 = 4'd2;
            A21 = 4'd3; A22 = 4'd4;

            B11 = 4'd5; B12 = 4'd6;
            B21 = 4'd7; B22 = 4'd8;





            #1;






            check_outputs(8'h13, 8'h16, 8'h2B, 8'h32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Values (Below 8-bit Overflow)", test_num);

            A11 = 4'd10; A12 = 4'd5;
            A21 = 4'd2;  A22 = 4'd8;

            B11 = 4'd7; B12 = 4'd4;
            B21 = 4'd3; B22 = 4'd9;





            #1;






            check_outputs(8'h55, 8'h55, 8'h26, 8'h50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Permutation Matrix Multiplication", test_num);

            A11 = 4'd4; A12 = 4'd2;
            A21 = 4'd1; A22 = 4'd3;

            B11 = 4'd0; B12 = 4'd1;
            B21 = 4'd1; B22 = 4'd0;





            #1;






            check_outputs(8'h02, 8'h04, 8'h03, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values (Handling Wrapping)", test_num);
            A11 = 4'hF; A12 = 4'hF;
            A21 = 4'hF; A22 = 4'hF;
            B11 = 4'hF; B12 = 4'hF;
            B21 = 4'hF; B22 = 4'hF;


            #1;



            check_outputs(8'hC2, 8'hC2, 8'hC2, 8'hC2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
