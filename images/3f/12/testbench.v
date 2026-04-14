`timescale 1ns/1ps

module matrix_mult_tb;

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
    matrix_mult dut (
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
        $display("Testcase %0d: Identity Matrix Multiplication", test_num);
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
        $display("Testcase %0d: Zero Matrix Multiplication", test_num);
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
        $display("Testcase %0d: Simple Matrix Multiplication", test_num);





        A00 = 8'd1; A01 = 8'd2;
        A10 = 8'd3; A11 = 8'd4;
        B00 = 8'd5; B01 = 8'd6;
        B10 = 8'd7; B11 = 8'd8;
        #1;

        check_outputs(16'd19, 16'd22, 16'd43, 16'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Values Multiplication", test_num);





        A00 = 8'd100; A01 = 8'd50;
        A10 = 8'd20;  A11 = 8'd10;
        B00 = 8'd10;  B01 = 8'd5;
        B10 = 8'd2;   B11 = 8'd1;
        #1;

        check_outputs(16'd1100, 16'd550, 16'd220, 16'd110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Inputs (Potential Overflow)", test_num);



        A00 = 8'd255; A01 = 8'd255;
        A10 = 8'd255; A11 = 8'd255;
        B00 = 8'd255; B01 = 8'd255;
        B10 = 8'd255; B11 = 8'd255;
        #1;

        check_outputs(16'hFC02, 16'hFC02, 16'hFC02, 16'hFC02);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mix of Values", test_num);





        A00 = 8'd255; A01 = 8'd1;
        A10 = 8'd0;   A11 = 8'd128;
        B00 = 8'd2;   B01 = 8'd0;
        B10 = 8'd10;  B11 = 8'd1;
        #1;

        check_outputs(16'd520, 16'd1, 16'd1280, 16'd128);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_mult Testbench");
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
