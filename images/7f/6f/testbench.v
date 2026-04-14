`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire nand_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .nand_out(nand_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs LOW", test_num);
        A = 2'b00;
        B = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single input HIGH (A[1])", test_num);
        A = 2'b10;
        B = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two inputs HIGH (A[1], A[0])", test_num);
        A = 2'b11;
        B = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two inputs HIGH (B[1], B[0])", test_num);
        A = 2'b00;
        B = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two inputs HIGH (A[0], B[0])", test_num);
        A = 2'b01;
        B = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three inputs HIGH (A[1], A[0], B[1])", test_num);
        A = 2'b11;
        B = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three inputs HIGH (A[0], B[1], B[0])", test_num);
        A = 2'b01;
        B = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All four inputs HIGH (Expect LOW output)", test_num);
        A = 2'b11;
        B = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check - One bit toggled LOW (A[1])", test_num);
        A = 2'b01;
        B = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check - One bit toggled LOW (B[0])", test_num);
        A = 2'b11;
        B = 2'b10;
        #1;

        check_outputs(1'b1);
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
        input expected_nand_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nand_out === (expected_nand_out ^ nand_out ^ expected_nand_out)) begin
                $display("PASS");
                $display("  Outputs: nand_out=%b",
                         nand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nand_out=%b",
                         expected_nand_out);
                $display("  Got:      nand_out=%b",
                         nand_out);
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
