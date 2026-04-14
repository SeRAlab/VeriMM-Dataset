`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire [3:0] A_inv;
    wire [3:0] B_inv;
    wire [3:0] C_inv;
    wire [3:0] D_inv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .A_inv(A_inv),
        .B_inv(B_inv),
        .C_inv(C_inv),
        .D_inv(D_inv)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Matrix", test_num);
            A = 4'h1; B = 4'h0; C = 4'h0; D = 4'h1;
            #1;

            check_outputs(4'h1, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Det = 1 (Case A)", test_num);
            A = 4'h2; B = 4'h1; C = 4'h1; D = 4'h1;
            #1;

            check_outputs(4'h1, 4'hF, 4'hF, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Det = -1 (Case A)", test_num);
            A = 4'h1; B = 4'h1; C = 4'h1; D = 4'h0;
            #1;

            check_outputs(4'h0, 4'h1, 4'h1, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Det = 1 (Case B)", test_num);
            A = 4'h3; B = 4'h2; C = 4'h1; D = 4'h1;
            #1;

            check_outputs(4'h1, 4'hE, 4'hF, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Det = -1 (Case B)", test_num);
            A = 4'h2; B = 4'h3; C = 4'h1; D = 4'h1;
            #1;

            check_outputs(4'hF, 4'h3, 4'h1, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Swap Matrix", test_num);
            A = 4'h0; B = 4'h1; C = 4'h1; D = 4'h0;
            #1;

            check_outputs(4'h0, 4'h1, 4'h1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper Triangular", test_num);
            A = 4'h1; B = 4'h2; C = 4'h0; D = 4'h1;
            #1;

            check_outputs(4'h1, 4'hE, 4'h0, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower Triangular", test_num);
            A = 4'h1; B = 4'h0; C = 4'h3; D = 4'h1;
            #1;

            check_outputs(4'h1, 4'h0, 4'hD, 4'h1);
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
        testcase008();
        
        
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
        input [3:0] expected_A_inv;
        input [3:0] expected_B_inv;
        input [3:0] expected_C_inv;
        input [3:0] expected_D_inv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_inv === (expected_A_inv ^ A_inv ^ expected_A_inv) &&
                expected_B_inv === (expected_B_inv ^ B_inv ^ expected_B_inv) &&
                expected_C_inv === (expected_C_inv ^ C_inv ^ expected_C_inv) &&
                expected_D_inv === (expected_D_inv ^ D_inv ^ expected_D_inv)) begin
                $display("PASS");
                $display("  Outputs: A_inv=%h, B_inv=%h, C_inv=%h, D_inv=%h",
                         A_inv, B_inv, C_inv, D_inv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_inv=%h, B_inv=%h, C_inv=%h, D_inv=%h",
                         expected_A_inv, expected_B_inv, expected_C_inv, expected_D_inv);
                $display("  Got:      A_inv=%h, B_inv=%h, C_inv=%h, D_inv=%h",
                         A_inv, B_inv, C_inv, D_inv);
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
