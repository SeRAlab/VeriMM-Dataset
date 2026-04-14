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
    wire [3:0] C00;
    wire [3:0] C01;
    wire [3:0] C10;
    wire [3:0] C11;

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
            $display("\nTest Case %0d: All Zeros", test_num);
            A00 = 4'h0; A01 = 4'h0; A10 = 4'h0; A11 = 4'h0;
            B00 = 4'h0; B01 = 4'h0; B10 = 4'h0; B11 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix Multiplication", test_num);

            A00 = 4'h2; A01 = 4'h3; A10 = 4'h4; A11 = 4'h5;

            B00 = 4'h1; B01 = 4'h0; B10 = 4'h0; B11 = 4'h1;
            #1;

            check_outputs(4'h2, 4'h3, 4'h4, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Matrix Multiplication", test_num);





            A00 = 4'h1; A01 = 4'h2; A10 = 4'h3; A11 = 4'h1;
            B00 = 4'h1; B01 = 4'h2; B10 = 4'h2; B11 = 4'h1;
            #1;

            check_outputs(4'h5, 4'h4, 4'h5, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result 15 (0xF)", test_num);


            A00 = 4'h3; A01 = 4'h2; A10 = 4'h0; A11 = 4'h0;
            B00 = 4'h3; B01 = 4'h0; B10 = 4'h3; B11 = 4'h0;
            #1;

            check_outputs(4'hF, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow Wrap (Result 16 -> 0)", test_num);


            A00 = 4'h4; A01 = 4'h0; A10 = 4'h0; A11 = 4'h0;
            B00 = 4'h4; B01 = 4'h0; B10 = 4'h0; B11 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Values with Wrap", test_num);





            A00 = 4'h5; A01 = 4'h2; A10 = 4'h3; A11 = 4'h4;
            B00 = 4'h2; B01 = 4'h1; B10 = 4'h3; B11 = 4'h2;
            #1;

            check_outputs(4'h0, 4'h9, 4'h2, 4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Input Values (0xF)", test_num);




            A00 = 4'hF; A01 = 4'hF; A10 = 4'hF; A11 = 4'hF;
            B00 = 4'hF; B01 = 4'hF; B10 = 4'hF; B11 = 4'hF;
            #1;

            check_outputs(4'h2, 4'h2, 4'h2, 4'h2);
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
        input [3:0] expected_C00;
        input [3:0] expected_C01;
        input [3:0] expected_C10;
        input [3:0] expected_C11;
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
