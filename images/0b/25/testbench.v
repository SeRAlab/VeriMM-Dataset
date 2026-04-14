`timescale 1ns/1ps

module matrix_mult_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a11;
    reg [3:0] a12;
    reg [3:0] a21;
    reg [3:0] a22;
    reg [3:0] b11;
    reg [3:0] b12;
    reg [3:0] b21;
    reg [3:0] b22;
    wire [7:0] c11;
    wire [7:0] c12;
    wire [7:0] c21;
    wire [7:0] c22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_mult dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .b11(b11),
        .b12(b12),
        .b21(b21),
        .b22(b22),
        .c11(c11),
        .c12(c12),
        .c21(c21),
        .c22(c22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix Multiplication", test_num);

            a11 = 4'd1; a12 = 4'd0;
            a21 = 4'd0; a22 = 4'd1;
            b11 = 4'd5; b12 = 4'd10;
            b21 = 4'd3; b22 = 4'd7;

            #1;


            check_outputs(8'd5, 8'd10, 8'd3, 8'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix Multiplication", test_num);

            a11 = 4'd0;  a12 = 4'd0;
            a21 = 4'd0;  a22 = 4'd0;
            b11 = 4'd15; b12 = 4'd15;
            b21 = 4'd15; b22 = 4'd15;

            #1;


            check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: General Values (Small)", test_num);

            a11 = 4'd1; a12 = 4'd2;
            a21 = 4'd3; a22 = 4'd4;
            b11 = 4'd5; b12 = 4'd6;
            b21 = 4'd7; b22 = 4'd8;




            #1;





            check_outputs(8'd19, 8'd22, 8'd43, 8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: General Values (Medium)", test_num);

            a11 = 4'd10; a12 = 4'd5;
            a21 = 4'd2;  a22 = 4'd8;
            b11 = 4'd4;  b12 = 4'd1;
            b21 = 4'd3;  b22 = 4'd6;




            #1;





            check_outputs(8'd55, 8'd40, 8'd32, 8'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Permutation Matrix", test_num);

            a11 = 4'd0; a12 = 4'd1;
            a21 = 4'd1; a22 = 4'd0;
            b11 = 4'd2; b12 = 4'd4;
            b21 = 4'd6; b22 = 4'd8;

            #1;


            check_outputs(8'd6, 8'd8, 8'd2, 8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values (Truncation Check)", test_num);

            a11 = 4'd15; a12 = 4'd15;
            a21 = 4'd15; a22 = 4'd15;
            b11 = 4'd15; b12 = 4'd15;
            b21 = 4'd15; b22 = 4'd15;



            #1;




            check_outputs(8'd194, 8'd194, 8'd194, 8'd194);
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
        input [7:0] expected_c11;
        input [7:0] expected_c12;
        input [7:0] expected_c21;
        input [7:0] expected_c22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c11 === (expected_c11 ^ c11 ^ expected_c11) &&
                expected_c12 === (expected_c12 ^ c12 ^ expected_c12) &&
                expected_c21 === (expected_c21 ^ c21 ^ expected_c21) &&
                expected_c22 === (expected_c22 ^ c22 ^ expected_c22)) begin
                $display("PASS");
                $display("  Outputs: c11=%h, c12=%h, c21=%h, c22=%h",
                         c11, c12, c21, c22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c11=%h, c12=%h, c21=%h, c22=%h",
                         expected_c11, expected_c12, expected_c21, expected_c22);
                $display("  Got:      c11=%h, c12=%h, c21=%h, c22=%h",
                         c11, c12, c21, c22);
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
