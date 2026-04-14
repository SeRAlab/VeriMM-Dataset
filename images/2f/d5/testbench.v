`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A00;
    reg [7:0] A01;
    reg [7:0] A10;
    reg [7:0] A11;
    reg [7:0] B00;
    reg [7:0] B01;
    reg [7:0] B10;
    reg [7:0] B11;
    wire [7:0] C00;
    wire [7:0] C01;
    wire [7:0] C10;
    wire [7:0] C11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiplier dut (
        .A00(A00),
        .A01(A01),
        .A10(A10),
        .A11(A11),
        .B00(B00),
        .B01(B01),
        .B10(B10),
        .B11(B11),
        .C00(C00),
        .C01(C01),
        .C10(C10),
        .C11(C11)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Matrix Multiplication (A * I = A)", test_num);

        A00 = 8'd5;  A01 = 8'd10;
        A10 = 8'd15; A11 = 8'd20;

        B00 = 8'd1;  B01 = 8'd0;
        B10 = 8'd0;  B11 = 8'd1;

        #1;


        check_outputs(8'd5, 8'd10, 8'd15, 8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Matrix Multiplication (A * 0 = 0)", test_num);

        A00 = 8'hFF; A01 = 8'hAA;
        A10 = 8'h55; A11 = 8'h01;

        B00 = 8'h00; B01 = 8'h00;
        B10 = 8'h00; B11 = 8'h00;

        #1;


        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Integer Calculation", test_num);

        A00 = 8'd1; A01 = 8'd2;
        A10 = 8'd3; A11 = 8'd4;

        B00 = 8'd5; B01 = 8'd6;
        B10 = 8'd7; B11 = 8'd8;




        #1;





        check_outputs(8'h13, 8'h16, 8'h2B, 8'h32);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow Modulo 256 Check", test_num);

        A00 = 8'd100; A01 = 8'd2;
        A10 = 8'd1;   A11 = 8'd50;
        B00 = 8'd3;   B01 = 8'd4;
        B10 = 8'd5;   B11 = 8'd6;




        #1;





        check_outputs(8'h36, 8'h9C, 8'hFD, 8'h30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Permutation Matrix Multiplication", test_num);

        A00 = 8'd10; A01 = 8'd20;
        A10 = 8'd30; A11 = 8'd40;

        B00 = 8'd0; B01 = 8'd1;
        B10 = 8'd1; B11 = 8'd0;




        #1;





        check_outputs(8'd20, 8'd10, 8'd40, 8'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Extreme Overflow Check", test_num);
        A00 = 8'hFF; A01 = 8'h01;
        A10 = 8'h01; A11 = 8'hFF;
        B00 = 8'h01; B01 = 8'h01;
        B10 = 8'h01; B11 = 8'h01;




        #1;





        check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiplier Testbench");
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
        input [7:0] expected_C00;
        input [7:0] expected_C01;
        input [7:0] expected_C10;
        input [7:0] expected_C11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C00 === (expected_C00 ^ C00 ^ expected_C00) &&
                expected_C01 === (expected_C01 ^ C01 ^ expected_C01) &&
                expected_C10 === (expected_C10 ^ C10 ^ expected_C10) &&
                expected_C11 === (expected_C11 ^ C11 ^ expected_C11)) begin
                $display("PASS");
                $display("  Outputs: C00=%h, C01=%h, C10=%h, C11=%h",
                         C00, C01, C10, C11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C00=%h, C01=%h, C10=%h, C11=%h",
                         expected_C00, expected_C01, expected_C10, expected_C11);
                $display("  Got:      C00=%h, C01=%h, C10=%h, C11=%h",
                         C00, C01, C10, C11);
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
