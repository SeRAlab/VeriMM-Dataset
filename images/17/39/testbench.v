`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] A;
    reg [8:0] B;
    wire [8:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Matrices (0 * 0)", test_num);
        A = 9'h000;
        B = 9'h000;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity * Identity", test_num);
        A = 9'b100_010_001;
        B = 9'b100_010_001;
        #1;

        check_outputs(9'b100_010_001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity * All-Ones", test_num);
        A = 9'b100_010_001;
        B = 9'h1FF;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All-Ones * Identity", test_num);
        A = 9'h1FF;
        B = 9'b100_010_001;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All-Ones * All-Ones", test_num);
        A = 9'h1FF;
        B = 9'h1FF;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Permutation/Shift Matrix Squared", test_num);
        A = 9'b010_001_100;
        B = 9'b010_001_100;
        #1;

        check_outputs(9'b001_100_010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse Matrices (XOR/Modulo 2 reduction)", test_num);
        A = 9'b110_000_001;
        B = 9'b100_100_001;
        #1;

        check_outputs(9'b000_000_001);
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
        input [8:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
