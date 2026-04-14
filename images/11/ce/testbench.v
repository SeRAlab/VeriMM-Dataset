`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
    wire [7:0] l11;
    wire [7:0] l12;
    wire [7:0] l21;
    wire [7:0] u11;
    wire [7:0] u12;
    wire [7:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .l11(l11),
        .l12(l12),
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Identity Matrix");
            a11 = 8'd1; a12 = 8'd0;
            a21 = 8'd0; a22 = 8'd1;

            #1;


            check_outputs(8'd1, 8'd0, 8'd0, 8'd1, 8'd0, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Matrix [[2, 4], [4, 11]]");
            a11 = 8'd2; a12 = 8'd4;
            a21 = 8'd4; a22 = 8'd11;


            #1;



            check_outputs(8'd1, 8'd0, 8'd2, 8'd2, 8'd4, 8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Matrix [[4, 8], [12, 30]]");
            a11 = 8'd4; a12 = 8'd8;
            a21 = 8'd12; a22 = 8'd30;


            #1;



            check_outputs(8'd1, 8'd0, 8'd3, 8'd4, 8'd8, 8'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Matrix [[3, 9], [6, 20]]");
            a11 = 8'd3; a12 = 8'd9;
            a21 = 8'd6; a22 = 8'd20;


            #1;



            check_outputs(8'd1, 8'd0, 8'd2, 8'd3, 8'd9, 8'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Matrix [[5, 10], [5, 15]]");
            a11 = 8'd5; a12 = 8'd10;
            a21 = 8'd5; a22 = 8'd15;


            #1;



            check_outputs(8'd1, 8'd0, 8'd1, 8'd5, 8'd10, 8'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Matrix [[10, 50], [20, 110]]");
            a11 = 8'd10; a12 = 8'd50;
            a21 = 8'd20; a22 = 8'd110;


            #1;



            check_outputs(8'd1, 8'd0, 8'd2, 8'd10, 8'd50, 8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Matrix with zero u22 [[2, 10], [4, 20]]");
            a11 = 8'd2; a12 = 8'd10;
            a21 = 8'd4; a22 = 8'd20;


            #1;



            check_outputs(8'd1, 8'd0, 8'd2, 8'd2, 8'd10, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Matrix with zero a12 [[4, 0], [8, 5]]");
            a11 = 8'd4; a12 = 8'd0;
            a21 = 8'd8; a22 = 8'd5;

            #1;


            check_outputs(8'd1, 8'd0, 8'd2, 8'd4, 8'd0, 8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
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
        input [7:0] expected_l11;
        input [7:0] expected_l12;
        input [7:0] expected_l21;
        input [7:0] expected_u11;
        input [7:0] expected_u12;
        input [7:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l12=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         l11, l12, l21, u11, u12, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l12=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         expected_l11, expected_l12, expected_l21, expected_u11, expected_u12, expected_u22);
                $display("  Got:      l11=%h, l12=%h, l21=%h, u11=%h, u12=%h, u22=%h",
                         l11, l12, l21, u11, u12, u22);
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
