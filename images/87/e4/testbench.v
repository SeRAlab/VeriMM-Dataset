`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] out_nand;
    wire [7:0] out_or;
    wire [3:0] out_prod;
    wire [3:0] out_quot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .out_nand(out_nand),
        .out_or(out_or),
        .out_prod(out_prod),
        .out_quot(out_quot)
    );
    task testcase001;

    begin
        A = 8'h02; B = 8'h03;
        $display("Test Case 001: A=%h, B=%h", A, B);
        #1;

        check_outputs(8'hFD, 8'h03, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        A = 8'hFF; B = 8'h00;
        $display("Test Case 002: A=%h, B=%h (Division by Zero)", A, B);
        #1;

        check_outputs(8'hFF, 8'hFF, 4'h0, 4'h0);
    end
        endtask

    task testcase003;

    begin
        A = 8'hFF; B = 8'hFF;
        $display("Test Case 003: A=%h, B=%h (Max Values)", A, B);


        #1;



        check_outputs(8'h00, 8'hFF, 4'hF, 4'h0);
    end
        endtask

    task testcase004;

    begin
        A = 8'hF0; B = 8'h01;
        $display("Test Case 004: A=%h, B=%h (Quotient MSB check)", A, B);

        #1;


        check_outputs(8'hFF, 8'hF1, 4'h0, 4'hF);
    end
        endtask

    task testcase005;

    begin
        A = 8'hAA; B = 8'h55;
        $display("Test Case 005: A=%h, B=%h", A, B);

        #1;


        check_outputs(8'hFF, 8'hFF, 4'h3, 4'h0);
    end
        endtask

    task testcase006;

    begin
        A = 8'hFF; B = 8'h02;
        $display("Test Case 006: A=%h, B=%h", A, B);

        #1;


        check_outputs(8'hFD, 8'hFF, 4'h0, 4'h7);
    end
        endtask

    task testcase007;

    begin
        A = 8'h80; B = 8'h80;
        $display("Test Case 007: A=%h, B=%h", A, B);

        #1;


        check_outputs(8'h7F, 8'h80, 4'h4, 4'h0);
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
        input [7:0] expected_out_nand;
        input [7:0] expected_out_or;
        input [3:0] expected_out_prod;
        input [3:0] expected_out_quot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_prod === (expected_out_prod ^ out_prod ^ expected_out_prod) &&
                expected_out_quot === (expected_out_quot ^ out_quot ^ expected_out_quot)) begin
                $display("PASS");
                $display("  Outputs: out_nand=%h, out_or=%h, out_prod=%h, out_quot=%h",
                         out_nand, out_or, out_prod, out_quot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_nand=%h, out_or=%h, out_prod=%h, out_quot=%h",
                         expected_out_nand, expected_out_or, expected_out_prod, expected_out_quot);
                $display("  Got:      out_nand=%h, out_or=%h, out_prod=%h, out_quot=%h",
                         out_nand, out_or, out_prod, out_quot);
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
