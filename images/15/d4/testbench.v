`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A11;
    reg [15:0] A12;
    reg [15:0] A21;
    reg [15:0] A22;
    wire [15:0] L11;
    wire [15:0] L12;
    wire [15:0] L21;
    wire [15:0] L22;
    wire [15:0] U11;
    wire [15:0] U12;
    wire [15:0] U21;
    wire [15:0] U22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22),
        .L11(L11),
        .L12(L12),
        .L21(L21),
        .L22(L22),
        .U11(U11),
        .U12(U12),
        .U21(U21),
        .U22(U22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);

            A11 = 16'h0001; A12 = 16'h0000;
            A21 = 16'h0000; A22 = 16'h0001;

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001, 16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Integer Decomposition", test_num);

            A11 = 16'h0002; A12 = 16'h0004;
            A21 = 16'h0004; A22 = 16'h000A;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001, 16'h0002, 16'h0004, 16'h0000, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger Multiples", test_num);

            A11 = 16'h0005; A12 = 16'h000F;
            A21 = 16'h0014; A22 = 16'h0046;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0004, 16'h0001, 16'h0005, 16'h000F, 16'h0000, 16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero A21 element", test_num);

            A11 = 16'h0003; A12 = 16'h0009;
            A21 = 16'h0000; A22 = 16'h000C;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001, 16'h0003, 16'h0009, 16'h0000, 16'h000C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Resulting U22", test_num);

            A11 = 16'h0002; A12 = 16'h0008;
            A21 = 16'h0006; A22 = 16'h0004;



            #1;




            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0002, 16'h0008, 16'h0000, 16'hFFEC);
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
        input [15:0] expected_L11;
        input [15:0] expected_L12;
        input [15:0] expected_L21;
        input [15:0] expected_L22;
        input [15:0] expected_U11;
        input [15:0] expected_U12;
        input [15:0] expected_U21;
        input [15:0] expected_U22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L11 === (expected_L11 ^ L11 ^ expected_L11) &&
                expected_L12 === (expected_L12 ^ L12 ^ expected_L12) &&
                expected_L21 === (expected_L21 ^ L21 ^ expected_L21) &&
                expected_L22 === (expected_L22 ^ L22 ^ expected_L22) &&
                expected_U11 === (expected_U11 ^ U11 ^ expected_U11) &&
                expected_U12 === (expected_U12 ^ U12 ^ expected_U12) &&
                expected_U21 === (expected_U21 ^ U21 ^ expected_U21) &&
                expected_U22 === (expected_U22 ^ U22 ^ expected_U22)) begin
                $display("PASS");
                $display("  Outputs: L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         L11, L12, L21, L22, U11, U12, U21, U22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         expected_L11, expected_L12, expected_L21, expected_L22, expected_U11, expected_U12, expected_U21, expected_U22);
                $display("  Got:      L11=%h, L12=%h, L21=%h, L22=%h, U11=%h, U12=%h, U21=%h, U22=%h",
                         L11, L12, L21, L22, U11, U12, U21, U22);
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
