`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix_A;
    reg [15:0] matrix_B;
    wire [15:0] factorized_A;
    wire [15:0] factorized_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .matrix_A(matrix_A),
        .matrix_B(matrix_B),
        .factorized_A(factorized_A),
        .factorized_B(factorized_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrices", test_num);

            matrix_A = 16'h0000;
            matrix_B = 16'h0000;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrices", test_num);

            matrix_A = 16'h1001;
            matrix_B = 16'h1001;

            #1;


            check_outputs(16'h1001, 16'h1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Values", test_num);

            matrix_A = 16'h1234;
            matrix_B = 16'h4321;

            #1;


            check_outputs(16'h0864, 16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Bit Width", test_num);

            matrix_A = 16'hFFFF;
            matrix_B = 16'hFFFF;
            #1;

            check_outputs(16'hEEEE, 16'hEEEE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sparse Matrices", test_num);

            matrix_A = 16'h0500;
            matrix_B = 16'h0007;
            #1;

            check_outputs(16'h0200, 16'h0003);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symmetric Matrices", test_num);

            matrix_A = 16'h2112;
            matrix_B = 16'h3113;
            #1;

            check_outputs(16'h1111, 16'h2112);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Patterns", test_num);
            matrix_A = 16'hA5A5;
            matrix_B = 16'h5A5A;
            #1;

            check_outputs(16'h5252, 16'h2525);
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
        input [15:0] expected_factorized_A;
        input [15:0] expected_factorized_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_factorized_A === (expected_factorized_A ^ factorized_A ^ expected_factorized_A) &&
                expected_factorized_B === (expected_factorized_B ^ factorized_B ^ expected_factorized_B)) begin
                $display("PASS");
                $display("  Outputs: factorized_A=%h, factorized_B=%h",
                         factorized_A, factorized_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: factorized_A=%h, factorized_B=%h",
                         expected_factorized_A, expected_factorized_B);
                $display("  Got:      factorized_A=%h, factorized_B=%h",
                         factorized_A, factorized_B);
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
