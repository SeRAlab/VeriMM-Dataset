`timescale 1ns/1ps

module matrix_inversion_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix_in;
    wire [15:0] matrix_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inversion_2x2 dut (
        .matrix_in(matrix_in),
        .matrix_out(matrix_out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Matrix", test_num);
        matrix_in = 16'h1001;
        #1;

        check_outputs(16'h1001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Singular Matrix (Linearly Dependent)", test_num);
        matrix_in = 16'h1111;
        #1;

        check_outputs(matrix_out, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Swapped Identity (Det = -1)", test_num);
        matrix_in = 16'h0110;
        #1;

        check_outputs(16'h0110, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Determinant 1 Matrix", test_num);
        matrix_in = 16'h2111;
        #1;

        check_outputs(16'h1FF2, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Determinant -1 Matrix", test_num);
        matrix_in = 16'h1211;
        #1;

        check_outputs(16'hF21F, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All-Zero Matrix", test_num);
        matrix_in = 16'h0000;
        #1;

        check_outputs(matrix_out, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Matrix with Det=1 (Values 3,2,1,1)", test_num);
        matrix_in = 16'h3211;
        #1;

        check_outputs(16'h1EF3, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inversion_2x2 Testbench");
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
        input [15:0] expected_matrix_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_matrix_out === (expected_matrix_out ^ matrix_out ^ expected_matrix_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: matrix_out=%h, valid=%b",
                         matrix_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: matrix_out=%h, valid=%b",
                         expected_matrix_out, expected_valid);
                $display("  Got:      matrix_out=%h, valid=%b",
                         matrix_out, valid);
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
