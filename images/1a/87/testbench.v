`timescale 1ns/1ps

module LU_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] L11;
    wire [3:0] L12;
    wire [3:0] U11;
    wire [3:0] U12;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .L11(L11),
        .L12(L12),
        .U11(U11),
        .U12(U12)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);

            a = 4'd1; b = 4'd0; c = 4'd0; d = 4'd1;

            #1;


            check_outputs(4'd0, 4'd1, 4'd1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Integer Division", test_num);

            a = 4'd2; b = 4'd2; c = 4'd4; d = 4'd6;

            #1;


            check_outputs(4'd2, 4'd2, 4'd2, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiples of a", test_num);

            a = 4'd3; b = 4'd1; c = 4'd6; d = 4'd7;

            #1;


            check_outputs(4'd2, 4'd5, 4'd3, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with Zero C", test_num);

            a = 4'd4; b = 4'd3; c = 4'd0; d = 4'd5;

            #1;


            check_outputs(4'd0, 4'd5, 4'd4, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Singular Matrix (Resulting in U22=0)", test_num);

            a = 4'd2; b = 4'd4; c = 4'd4; d = 4'd8;

            #1;


            check_outputs(4'd2, 4'd0, 4'd2, 4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Numbers", test_num);

            a = 4'd1; b = 4'd5; c = 4'd3; d = 4'd15;

            #1;


            check_outputs(4'd3, 4'd0, 4'd1, 4'd5);
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
        input [3:0] expected_L11;
        input [3:0] expected_L12;
        input [3:0] expected_U11;
        input [3:0] expected_U12;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L11 === (expected_L11 ^ L11 ^ expected_L11) &&
                expected_L12 === (expected_L12 ^ L12 ^ expected_L12) &&
                expected_U11 === (expected_U11 ^ U11 ^ expected_U11) &&
                expected_U12 === (expected_U12 ^ U12 ^ expected_U12)) begin
                $display("PASS");
                $display("  Outputs: L11=%h, L12=%h, U11=%h, U12=%h",
                         L11, L12, U11, U12);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L11=%h, L12=%h, U11=%h, U12=%h",
                         expected_L11, expected_L12, expected_U11, expected_U12);
                $display("  Got:      L11=%h, L12=%h, U11=%h, U12=%h",
                         L11, L12, U11, U12);
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
