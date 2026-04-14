`timescale 1ns/1ps

module LU_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A0;
    reg [7:0] A1;
    reg [7:0] A2;
    reg [7:0] A3;
    wire [7:0] L0;
    wire [7:0] L1;
    wire [7:0] U0;
    wire [7:0] U1;
    wire [7:0] U2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_decomposition dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .L0(L0),
        .L1(L1),
        .U0(U0),
        .U1(U1),
        .U2(U2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple integer division (exact)", test_num);

            A0 = 8'd4; A1 = 8'd2; A2 = 8'd8; A3 = 8'd10;

            #1;


            check_outputs(8'd4, 8'd2, 8'd4, 8'd2, 8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger multipliers", test_num);

            A0 = 8'd10; A1 = 8'd20; A2 = 8'd30; A3 = 8'd100;

            #1;


            check_outputs(8'd10, 8'd3, 8'd10, 8'd20, 8'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Non-exact division (integer truncation)", test_num);

            A0 = 8'd5; A1 = 8'd3; A2 = 8'd12; A3 = 8'd10;

            #1;


            check_outputs(8'd5, 8'd2, 8'd5, 8'd3, 8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with ones", test_num);

            A0 = 8'd1; A1 = 8'd1; A2 = 8'd1; A3 = 8'd1;

            #1;


            check_outputs(8'd1, 8'd1, 8'd1, 8'd1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero in lower left", test_num);

            A0 = 8'd2; A1 = 8'd10; A2 = 8'd0; A3 = 8'd5;

            #1;


            check_outputs(8'd2, 8'd0, 8'd2, 8'd10, 8'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Higher division result", test_num);

            A0 = 8'd3; A1 = 8'd4; A2 = 8'd27; A3 = 8'd40;

            #1;


            check_outputs(8'd3, 8'd9, 8'd3, 8'd4, 8'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values nearing 8-bit limit", test_num);

            A0 = 8'd12; A1 = 8'd5; A2 = 8'd120; A3 = 8'd100;

            #1;


            check_outputs(8'd12, 8'd10, 8'd12, 8'd5, 8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_decomposition Testbench");
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
        input [7:0] expected_L0;
        input [7:0] expected_L1;
        input [7:0] expected_U0;
        input [7:0] expected_U1;
        input [7:0] expected_U2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L0 === (expected_L0 ^ L0 ^ expected_L0) &&
                expected_L1 === (expected_L1 ^ L1 ^ expected_L1) &&
                expected_U0 === (expected_U0 ^ U0 ^ expected_U0) &&
                expected_U1 === (expected_U1 ^ U1 ^ expected_U1) &&
                expected_U2 === (expected_U2 ^ U2 ^ expected_U2)) begin
                $display("PASS");
                $display("  Outputs: L0=%h, L1=%h, U0=%h, U1=%h, U2=%h",
                         L0, L1, U0, U1, U2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L0=%h, L1=%h, U0=%h, U1=%h, U2=%h",
                         expected_L0, expected_L1, expected_U0, expected_U1, expected_U2);
                $display("  Got:      L0=%h, L1=%h, U0=%h, U1=%h, U2=%h",
                         L0, L1, U0, U1, U2);
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
