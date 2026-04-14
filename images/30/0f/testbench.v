`timescale 1ns/1ps

module matrix_mult_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A11;
    reg [31:0] A12;
    reg [31:0] A21;
    reg [31:0] A22;
    reg [31:0] B11;
    reg [31:0] B12;
    reg [31:0] B21;
    reg [31:0] B22;
    wire [31:0] C11;
    wire [31:0] C12;
    wire [31:0] C21;
    wire [31:0] C22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_mult dut (
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
            $display("Test Case %0d: Identity Matrix Multiplication (A * I = A)", test_num);

            A11 = 32'd5;  A12 = 32'd10;
            A21 = 32'd15; A22 = 32'd20;

            B11 = 32'd1;  B12 = 32'd0;
            B21 = 32'd0;  B22 = 32'd1;


            #1;



            check_outputs(32'd5, 32'd10, 32'd15, 32'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Zero Matrix Multiplication (A * 0 = 0)", test_num);

            A11 = 32'hFFFF_FFFF; A12 = 32'h1234_5678;
            A21 = 32'hAAAA_BBBB; A22 = 32'h0000_1111;

            B11 = 32'd0; B12 = 32'd0;
            B21 = 32'd0; B22 = 32'd0;


            #1;



            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Simple Integers", test_num);

            A11 = 32'd1; A12 = 32'd1;
            A21 = 32'd1; A22 = 32'd1;

            B11 = 32'd2; B12 = 32'd2;
            B21 = 32'd2; B22 = 32'd2;


            #1;



            check_outputs(32'd4, 32'd4, 32'd4, 32'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: General Matrix Multiplication", test_num);

            A11 = 32'd2; A12 = 32'd3;
            A21 = 32'd4; A22 = 32'd5;

            B11 = 32'd1; B12 = 32'd2;
            B21 = 32'd3; B22 = 32'd4;





            #1;






            check_outputs(32'd11, 32'd16, 32'd19, 32'd28);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: B * A with different values", test_num);

            A11 = 32'd1; A12 = 32'd2;
            A21 = 32'd3; A22 = 32'd4;

            B11 = 32'd2; B12 = 32'd3;
            B21 = 32'd4; B22 = 32'd5;





            #1;






            check_outputs(32'd10, 32'd13, 32'd22, 32'd29);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiplication by Scalar 10", test_num);

            A11 = 32'd100; A12 = 32'd200;
            A21 = 32'd300; A22 = 32'd400;

            B11 = 32'd10;  B12 = 32'd0;
            B21 = 32'd0;   B22 = 32'd10;


            #1;



            check_outputs(32'd1000, 32'd2000, 32'd3000, 32'd4000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_mult Testbench");
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
        input [31:0] expected_C11;
        input [31:0] expected_C12;
        input [31:0] expected_C21;
        input [31:0] expected_C22;
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
