`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] Difference;
    wire [7:0] Product;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Difference(Difference),
        .Product(Product),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h00, 8'h00, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd3;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h02, 8'h0F, 5'h08);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd3; B = 4'd5;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h1E, 8'h0F, 5'h08);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd15;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h00, 8'hE1, 5'h1E);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd0;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h0F, 8'h00, 5'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd15;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h11, 8'h00, 5'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd4;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h04, 8'h20, 5'h0C);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd7; B = 4'd7;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h00, 8'h31, 5'h0E);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd1; B = 4'd2;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h1F, 8'h02, 5'h03);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd13; B = 4'd1;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(5'h0C, 8'h0D, 5'h0E);
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
        input [4:0] expected_Difference;
        input [7:0] expected_Product;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Difference === (expected_Difference ^ Difference ^ expected_Difference) &&
                expected_Product === (expected_Product ^ Product ^ expected_Product) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Difference=%h, Product=%h, Sum=%h",
                         Difference, Product, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Difference=%h, Product=%h, Sum=%h",
                         expected_Difference, expected_Product, expected_Sum);
                $display("  Got:      Difference=%h, Product=%h, Sum=%h",
                         Difference, Product, Sum);
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
