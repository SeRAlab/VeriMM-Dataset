`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix_in;
    wire [15:0] matrix_out1;
    wire [15:0] matrix_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .matrix_in(matrix_in),
        .matrix_out1(matrix_out1),
        .matrix_out2(matrix_out2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Identity Matrix", test_num);
        matrix_in = 16'h1001;
        #1;

        check_outputs(16'h1001, 16'h1001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Simple LU Factorization", test_num);
        matrix_in = 16'h2449;
        #1;

        check_outputs(16'h1021, 16'h2401);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: LU with different ratios", test_num);
        matrix_in = 16'h1237;
        #1;

        check_outputs(16'h1031, 16'h1201);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Scaling and Remainder", test_num);
        matrix_in = 16'h3639;
        #1;

        check_outputs(16'h1011, 16'h3603);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Matrix with large hex values", test_num);
        matrix_in = 16'h246F;
        #1;

        check_outputs(16'h1031, 16'h2403);
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
        input [15:0] expected_matrix_out1;
        input [15:0] expected_matrix_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_matrix_out1 === (expected_matrix_out1 ^ matrix_out1 ^ expected_matrix_out1) &&
                expected_matrix_out2 === (expected_matrix_out2 ^ matrix_out2 ^ expected_matrix_out2)) begin
                $display("PASS");
                $display("  Outputs: matrix_out1=%h, matrix_out2=%h",
                         matrix_out1, matrix_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: matrix_out1=%h, matrix_out2=%h",
                         expected_matrix_out1, expected_matrix_out2);
                $display("  Got:      matrix_out1=%h, matrix_out2=%h",
                         matrix_out1, matrix_out2);
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
