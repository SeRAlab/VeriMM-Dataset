`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] M00;
    reg [7:0] M01;
    reg [7:0] M10;
    reg [7:0] M11;
    wire [7:0] A00;
    wire [7:0] A01;
    wire [7:0] A10;
    wire [7:0] A11;
    wire [7:0] B00;
    wire [7:0] B01;
    wire [7:0] B10;
    wire [7:0] B11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .M00(M00),
        .M01(M01),
        .M10(M10),
        .M11(M11),
        .A00(A00),
        .A01(A01),
        .A10(A10),
        .A11(A11),
        .B00(B00),
        .B01(B01),
        .B10(B10),
        .B11(B11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix", test_num);
            M00 = 8'd1; M01 = 8'd0;
            M10 = 8'd0; M11 = 8'd1;
            #1;

            check_outputs(8'd1, 8'd0, 8'd0, 8'd1, 8'd1, 8'd0, 8'd0, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple LU Factorable Matrix", test_num);
            M00 = 8'd2; M01 = 8'd4;
            M10 = 8'd6; M11 = 8'd20;
            #1;

            check_outputs(8'd1, 8'd0, 8'd3, 8'd1, 8'd2, 8'd4, 8'd0, 8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix", test_num);
            M00 = 8'd0; M01 = 8'd0;
            M10 = 8'd0; M11 = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal Matrix", test_num);
            M00 = 8'd10; M01 = 8'd0;
            M10 = 8'd0;  M11 = 8'd20;
            #1;

            check_outputs(8'd1, 8'd0, 8'd0, 8'd1, 8'd10, 8'd0, 8'd0, 8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values", test_num);
            M00 = 8'd5;  M01 = 8'd10;
            M10 = 8'd15; M11 = 8'd40;
            #1;

            check_outputs(8'd1, 8'd0, 8'd3, 8'd1, 8'd5, 8'd10, 8'd0, 8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Gradient", test_num);
            M00 = 8'd1; M01 = 8'd1;
            M10 = 8'd1; M11 = 8'd2;
            #1;

            check_outputs(8'd1, 8'd0, 8'd1, 8'd1, 8'd1, 8'd1, 8'd0, 8'd1);
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
        input [7:0] expected_A00;
        input [7:0] expected_A01;
        input [7:0] expected_A10;
        input [7:0] expected_A11;
        input [7:0] expected_B00;
        input [7:0] expected_B01;
        input [7:0] expected_B10;
        input [7:0] expected_B11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A00 === (expected_A00 ^ A00 ^ expected_A00) &&
                expected_A01 === (expected_A01 ^ A01 ^ expected_A01) &&
                expected_A10 === (expected_A10 ^ A10 ^ expected_A10) &&
                expected_A11 === (expected_A11 ^ A11 ^ expected_A11) &&
                expected_B00 === (expected_B00 ^ B00 ^ expected_B00) &&
                expected_B01 === (expected_B01 ^ B01 ^ expected_B01) &&
                expected_B10 === (expected_B10 ^ B10 ^ expected_B10) &&
                expected_B11 === (expected_B11 ^ B11 ^ expected_B11)) begin
                $display("PASS");
                $display("  Outputs: A00=%h, A01=%h, A10=%h, A11=%h, B00=%h, B01=%h, B10=%h, B11=%h",
                         A00, A01, A10, A11, B00, B01, B10, B11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A00=%h, A01=%h, A10=%h, A11=%h, B00=%h, B01=%h, B10=%h, B11=%h",
                         expected_A00, expected_A01, expected_A10, expected_A11, expected_B00, expected_B01, expected_B10, expected_B11);
                $display("  Got:      A00=%h, A01=%h, A10=%h, A11=%h, B00=%h, B01=%h, B10=%h, B11=%h",
                         A00, A01, A10, A11, B00, B01, B10, B11);
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
