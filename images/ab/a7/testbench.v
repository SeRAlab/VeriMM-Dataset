`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0000;
        B = 16'h0000;
        $display("Test %0d: All Zeros Matrix", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h8421;
        B = 16'h8421;
        $display("Test %0d: Identity * Identity", test_num);
        #1;

        check_outputs(16'h8421);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'hABCD;
        B = 16'h8421;
        $display("Test %0d: Matrix A * Identity", test_num);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'h8421;
        B = 16'h5555;
        $display("Test %0d: Identity * Matrix B", test_num);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFF;
        B = 16'h0000;
        $display("Test %0d: All Ones * Zero Matrix", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        A = 16'h4821;
        B = 16'h4821;
        $display("Test %0d: Permutation Matrix Squared", test_num);
        #1;

        check_outputs(16'h8421);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h1000;
        B = 16'h000F;
        $display("Test %0d: Sparse Row/Column intersection", test_num);
        #1;

        check_outputs(16'hF000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h8020;
        B = 16'h0401;
        $display("Test %0d: Complementary Diagonals", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'h1248;
        B = 16'h1248;
        $display("Test %0d: Anti-diagonal Squared", test_num);
        #1;

        check_outputs(16'h8421);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 16'h8421;
        B = 16'h4218;
        $display("Test %0d: Identity * Shift Matrix", test_num);
        #1;

        check_outputs(16'h4218);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_C;
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
