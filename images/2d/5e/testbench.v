`timescale 1ns/1ps

module matrix_mult_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg [3:0] B0;
    reg [3:0] B1;
    reg [3:0] B2;
    reg [3:0] B3;
    wire [3:0] C0;
    wire [3:0] C1;
    wire [3:0] C2;
    wire [3:0] C3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_mult dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C0(C0),
        .C1(C1),
        .C2(C2),
        .C3(C3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Matrix Multiplication (A * I = A)", test_num);

            A0 = 4'd5; A1 = 4'd2; A2 = 4'd8; A3 = 4'd3;

            B0 = 4'd1; B1 = 4'd0; B2 = 4'd0; B3 = 4'd1;

            #1;


            check_outputs(4'd5, 4'd2, 4'd8, 4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Matrix Multiplication (A * 0 = 0)", test_num);
            A0 = 4'd7; A1 = 4'd15; A2 = 4'd2; A3 = 4'd4;
            B0 = 4'd0; B1 = 4'd0; B2 = 4'd0; B3 = 4'd0;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Calculation (No Overflow)", test_num);





            A0 = 4'd2; A1 = 4'd1; A2 = 4'd1; A3 = 4'd2;
            B0 = 4'd1; B1 = 4'd2; B2 = 4'd3; B3 = 4'd1;
            #1;

            check_outputs(4'd5, 4'd5, 4'd7, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow/Truncation Test (Modulo 16 Arithmetic)", test_num);


            A0 = 4'd4; A1 = 4'd4; A2 = 4'd4; A3 = 4'd4;
            B0 = 4'd4; B1 = 4'd4; B2 = 4'd4; B3 = 4'd4;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Values with Partial Truncation", test_num);





            A0 = 4'd2; A1 = 4'd3; A2 = 4'd1; A3 = 4'd0;
            B0 = 4'd5; B1 = 4'd2; B2 = 4'd1; B3 = 4'd4;
            #1;

            check_outputs(4'hD, 4'h0, 4'h5, 4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Bit Values", test_num);





            A0 = 4'd1; A1 = 4'd1; A2 = 4'd1; A3 = 4'd1;
            B0 = 4'd15; B1 = 4'd0; B2 = 4'd0; B3 = 4'd15;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
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
        input [3:0] expected_C0;
        input [3:0] expected_C1;
        input [3:0] expected_C2;
        input [3:0] expected_C3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C0 === (expected_C0 ^ C0 ^ expected_C0) &&
                expected_C1 === (expected_C1 ^ C1 ^ expected_C1) &&
                expected_C2 === (expected_C2 ^ C2 ^ expected_C2) &&
                expected_C3 === (expected_C3 ^ C3 ^ expected_C3)) begin
                $display("PASS");
                $display("  Outputs: C0=%h, C1=%h, C2=%h, C3=%h",
                         C0, C1, C2, C3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C0=%h, C1=%h, C2=%h, C3=%h",
                         expected_C0, expected_C1, expected_C2, expected_C3);
                $display("  Got:      C0=%h, C1=%h, C2=%h, C3=%h",
                         C0, C1, C2, C3);
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
