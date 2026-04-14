`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a11;
    reg [31:0] a12;
    reg [31:0] a21;
    reg [31:0] a22;
    wire [31:0] b11;
    wire [31:0] b12;
    wire [31:0] b21;
    wire [31:0] b22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .b11(b11),
        .b12(b12),
        .b21(b21),
        .b22(b22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Matrix (Invertible, Det=1)", test_num);

            a11 = 32'd1; a12 = 32'd0;
            a21 = 32'd0; a22 = 32'd1;
            #1;

            check_outputs(32'd1, 32'd0, 32'd0, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-Zero Matrix (Non-Invertible, Det=0)", test_num);

            a11 = 32'd0; a12 = 32'd0;
            a21 = 32'd0; a22 = 32'd0;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Matrix with Det=1", test_num);


            a11 = 32'd3; a12 = 32'd2;
            a21 = 32'd4; a22 = 32'd3;

            #1;


            check_outputs(32'd3, 32'hFFFFFFFE, 32'hFFFFFFFC, 32'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Singular Matrix (Linearly Dependent Rows, Det=0)", test_num);

            a11 = 32'd1; a12 = 32'd2;
            a21 = 32'd2; a22 = 32'd4;
            #1;

            check_outputs(32'd0, 32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Matrix with Det=-1", test_num);


            a11 = 32'd1; a12 = 32'd2;
            a21 = 32'd1; a22 = 32'd1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'd2, 32'd1, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Permutation Matrix (Invertible, Det=-1)", test_num);


            a11 = 32'd0; a12 = 32'd1;
            a21 = 32'd1; a22 = 32'd0;
            #1;

            check_outputs(32'd0, 32'd1, 32'd1, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Matrix with larger integers (Det=1)", test_num);


            a11 = 32'd7; a12 = 32'd3;
            a21 = 32'd2; a22 = 32'd1;

            #1;


            check_outputs(32'd1, 32'hFFFFFFFD, 32'hFFFFFFFE, 32'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [31:0] expected_b11;
        input [31:0] expected_b12;
        input [31:0] expected_b21;
        input [31:0] expected_b22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b11 === (expected_b11 ^ b11 ^ expected_b11) &&
                expected_b12 === (expected_b12 ^ b12 ^ expected_b12) &&
                expected_b21 === (expected_b21 ^ b21 ^ expected_b21) &&
                expected_b22 === (expected_b22 ^ b22 ^ expected_b22)) begin
                $display("PASS");
                $display("  Outputs: b11=%h, b12=%h, b21=%h, b22=%h",
                         b11, b12, b21, b22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b11=%h, b12=%h, b21=%h, b22=%h",
                         expected_b11, expected_b12, expected_b21, expected_b22);
                $display("  Got:      b11=%h, b12=%h, b21=%h, b22=%h",
                         b11, b12, b21, b22);
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
