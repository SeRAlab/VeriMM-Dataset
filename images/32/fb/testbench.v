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
    wire [15:0] R00;
    wire [15:0] R01;
    wire [15:0] R10;
    wire [15:0] R11;

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
        .R00(R00),
        .R01(R01),
        .R10(R10),
        .R11(R11)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix Multiplication (A * I)", test_num);

            A00 = 8'd1; A01 = 8'd2; A10 = 8'd3; A11 = 8'd4;
            B00 = 8'd1; B01 = 8'd0; B10 = 8'd0; B11 = 8'd1;

            #1;


            check_outputs(16'h0001, 16'h0002, 16'h0003, 16'h0004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Matrix Multiplication (A * 0)", test_num);

            A00 = 8'd5;  A01 = 8'd10; A10 = 8'd15; A11 = 8'd20;
            B00 = 8'd0;  B01 = 8'd0;  B10 = 8'd0;  B11 = 8'd0;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Integer Multiplication", test_num);





            A00 = 8'd2; A01 = 8'd3; A10 = 8'd4; A11 = 8'd5;
            B00 = 8'd1; B01 = 8'd2; B10 = 8'd3; B11 = 8'd4;
            #1;

            check_outputs(16'h000B, 16'h0010, 16'h0013, 16'h001C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Accumulation of Max 8-bit values", test_num);


            A00 = 8'd1;   A01 = 8'd1;   A10 = 8'd1;   A11 = 8'd1;
            B00 = 8'd255; B01 = 8'd255; B10 = 8'd255; B11 = 8'd255;
            #1;

            check_outputs(16'h01FE, 16'h01FE, 16'h01FE, 16'h01FE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Product Results", test_num);


            A00 = 8'd128; A01 = 8'd0;   A10 = 8'd0;   A11 = 8'd128;
            B00 = 8'd128; B01 = 8'd128; B10 = 8'd128; B11 = 8'd128;
            #1;

            check_outputs(16'h4000, 16'h4000, 16'h4000, 16'h4000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed values", test_num);





            A00 = 8'd10; A01 = 8'd20; A10 = 8'd30; A11 = 8'd40;
            B00 = 8'd5;  B01 = 8'd6;  B10 = 8'd7;  B11 = 8'd8;
            #1;

            check_outputs(16'h00BE, 16'h00DC, 16'h01AE, 16'h01F4);
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
        input [15:0] expected_R00;
        input [15:0] expected_R01;
        input [15:0] expected_R10;
        input [15:0] expected_R11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R00 === (expected_R00 ^ R00 ^ expected_R00) &&
                expected_R01 === (expected_R01 ^ R01 ^ expected_R01) &&
                expected_R10 === (expected_R10 ^ R10 ^ expected_R10) &&
                expected_R11 === (expected_R11 ^ R11 ^ expected_R11)) begin
                $display("PASS");
                $display("  Outputs: R00=%h, R01=%h, R10=%h, R11=%h",
                         R00, R01, R10, R11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R00=%h, R01=%h, R10=%h, R11=%h",
                         expected_R00, expected_R01, expected_R10, expected_R11);
                $display("  Got:      R00=%h, R01=%h, R10=%h, R11=%h",
                         R00, R01, R10, R11);
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
