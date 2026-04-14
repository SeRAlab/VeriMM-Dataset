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
    wire [15:0] C00;
    wire [15:0] C01;
    wire [15:0] C10;
    wire [15:0] C11;

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
            $display("Test Case %0d: Identity Matrix Multiplication (A * I)", test_num);

            A00 = 8'd10; A01 = 8'd20;
            A10 = 8'd30; A11 = 8'd40;

            B00 = 8'd1;  B01 = 8'd0;
            B10 = 8'd0;  B11 = 8'd1;


            #1;



            check_outputs(16'd10, 16'd20, 16'd30, 16'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Matrix Multiplication", test_num);

            A00 = 8'hFF; A01 = 8'hFF;
            A10 = 8'hFF; A11 = 8'hFF;

            B00 = 8'd0;  B01 = 8'd0;
            B10 = 8'd0;  B11 = 8'd0;

            #1;


            check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Multiplication", test_num);

            A00 = 8'd2; A01 = 8'd3;
            A10 = 8'd4; A11 = 8'd5;

            B00 = 8'd6; B01 = 8'd7;
            B10 = 8'd8; B11 = 8'd9;





            #1;






            check_outputs(16'd36, 16'd41, 16'd64, 16'd73);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Matrix", test_num);
            A00 = 8'd1; A01 = 8'd1;
            A10 = 8'd1; A11 = 8'd1;
            B00 = 8'd1; B01 = 8'd1;
            B10 = 8'd1; B11 = 8'd1;


            #1;



            check_outputs(16'd2, 16'd2, 16'd2, 16'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger Values", test_num);

            A00 = 8'd100; A01 = 8'd100;
            A10 = 8'd100; A11 = 8'd100;

            B00 = 8'd50;  B01 = 8'd60;
            B10 = 8'd70;  B11 = 8'd80;





            #1;






            check_outputs(16'd12000, 16'd14000, 16'd12000, 16'd14000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs (Truncation Check)", test_num);
            A00 = 8'hFF; A01 = 8'hFF;
            A10 = 8'hFF; A11 = 8'hFF;
            B00 = 8'hFF; B01 = 8'hFF;
            B10 = 8'hFF; B11 = 8'hFF;


            #1;



            check_outputs(16'hFC02, 16'hFC02, 16'hFC02, 16'hFC02);
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
        input [15:0] expected_C00;
        input [15:0] expected_C01;
        input [15:0] expected_C10;
        input [15:0] expected_C11;
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
