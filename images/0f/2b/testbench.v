`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix_in;
    wire [15:0] matrix_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .matrix_in(matrix_in),
        .matrix_out(matrix_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            matrix_in = {4'h1, 4'h0, 4'h0, 4'h1};
            #1;

            check_outputs({4'h1, 4'h0, 4'h0, 4'h1});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant = 1", test_num);
            matrix_in = {4'h2, 4'h1, 4'h1, 4'h1};
            #1;

            check_outputs({4'h1, 4'hF, 4'hF, 4'h2});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant = -1", test_num);
            matrix_in = {4'h1, 4'h1, 4'h1, 4'h0};
            #1;

            check_outputs({4'h0, 4'h1, 4'h1, 4'hF});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Anti-diagonal Matrix", test_num);
            matrix_in = {4'h0, 4'h1, 4'h1, 4'h0};
            #1;

            check_outputs({4'h0, 4'h1, 4'h1, 4'h0});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Larger values Det = 1", test_num);
            matrix_in = {4'h3, 4'h2, 4'h4, 4'h3};
            #1;

            check_outputs({4'h3, 4'hE, 4'hC, 4'h3});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Inputs", test_num);
            matrix_in = {4'hF, 4'h0, 4'h0, 4'hF};
            #1;

            check_outputs({4'hF, 4'h0, 4'h0, 4'hF});
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_matrix_out === (expected_matrix_out ^ matrix_out ^ expected_matrix_out)) begin
                $display("PASS");
                $display("  Outputs: matrix_out=%h",
                         matrix_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: matrix_out=%h",
                         expected_matrix_out);
                $display("  Got:      matrix_out=%h",
                         matrix_out);
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
