`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A00;
    reg [3:0] A01;
    reg [3:0] A10;
    reg [3:0] A11;
    reg [3:0] B00;
    reg [3:0] B01;
    reg [3:0] B10;
    reg [3:0] B11;
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
            $display("Testcase %0d: Identity Matrix A * B", test_num);

            A00 = 4'd1; A01 = 4'd0;
            A10 = 4'd0; A11 = 4'd1;

            B00 = 4'd5; B01 = 4'd3;
            B10 = 4'd2; B11 = 4'd4;

            #1;


            check_outputs(8'd5, 8'd3, 8'd2, 8'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A * Identity Matrix B", test_num);

            A00 = 4'd7; A01 = 4'd8;
            A10 = 4'd9; A11 = 4'd2;

            B00 = 4'd1; B01 = 4'd0;
            B10 = 4'd0; B11 = 4'd1;

            #1;


            check_outputs(8'd7, 8'd8, 8'd9, 8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero Matrix", test_num);

            A00 = 4'd15; A01 = 4'd15;
            A10 = 4'd15; A11 = 4'd15;

            B00 = 4'd0; B01 = 4'd0;
            B10 = 4'd0; B11 = 4'd0;

            #1;


            check_outputs(8'd0, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Values Multiplication", test_num);

            A00 = 4'd2; A01 = 4'd1;
            A10 = 4'd3; A11 = 4'd4;

            B00 = 4'd1; B01 = 4'd2;
            B10 = 4'd3; B11 = 4'd1;




            #1;





            check_outputs(8'd5, 8'd5, 8'd15, 8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniform Elements (All Ones)", test_num);

            A00 = 4'd1; A01 = 4'd1;
            A10 = 4'd1; A11 = 4'd1;

            B00 = 4'd1; B01 = 4'd1;
            B10 = 4'd1; B11 = 4'd1;

            #1;


            check_outputs(8'd2, 8'd2, 8'd2, 8'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Resulting in Mid-range Values", test_num);

            A00 = 4'd5; A01 = 4'd5;
            A10 = 4'd5; A11 = 4'd5;

            B00 = 4'd5; B01 = 4'd5;
            B10 = 4'd5; B11 = 4'd5;

            #1;


            check_outputs(8'd50, 8'd50, 8'd50, 8'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (Near 8-bit Boundary)", test_num);

            A00 = 4'd10; A01 = 4'd5;
            A10 = 4'd8;  A11 = 4'd12;

            B00 = 4'd12; B01 = 4'd8;
            B10 = 4'd5;  B11 = 4'd10;




            #1;





            check_outputs(8'd145, 8'd130, 8'd156, 8'd184);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Mix", test_num);

            A00 = 4'd1;  A01 = 4'd15;
            A10 = 4'd0;  A11 = 4'd4;

            B00 = 4'd15; B01 = 4'd2;
            B10 = 4'd1;  B11 = 4'd3;




            #1;





            check_outputs(8'd30, 8'd47, 8'd4, 8'd12);
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
        testcase007();
        testcase008();
        
        
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
