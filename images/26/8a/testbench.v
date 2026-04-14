`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] q1;
    wire [3:0] q2;
    wire [3:0] r11;
    wire [3:0] r12;
    wire [3:0] r22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a(a),
        .b(b),
        .q1(q1),
        .q2(q2),
        .r11(r11),
        .r12(r12),
        .r22(r22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);

            a = 4'h4;
            b = 4'h1;
            #1;

            check_outputs(4'h4, 4'h1, 4'h1, 4'h0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scaled Identity Matrix", test_num);

            a = 4'h8;
            b = 4'h2;
            #1;

            check_outputs(4'h4, 4'h1, 4'h2, 4'h0, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Triangular Matrix", test_num);

            a = 4'h5;
            b = 4'h1;
            #1;

            check_outputs(4'h4, 4'h1, 4'h1, 4'h1, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Permutation Matrix (Row Swap)", test_num);

            a = 4'h1;
            b = 4'h4;
            #1;

            check_outputs(4'h1, 4'h4, 4'h1, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Matrix", test_num);
            a = 4'h0;
            b = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with Col 1 Scaled", test_num);
            a = 4'h8;
            b = 4'h1;
            #1;

            check_outputs(4'h4, 4'h1, 4'h2, 4'h0, 4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bottom-Heavy Col 1", test_num);
            a = 4'h0;
            b = 4'h5;
            #1;

            check_outputs(4'h1, 4'h4, 4'h1, 4'h1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Matrix", test_num);
            a = 4'h4;
            b = 4'h2;
            #1;

            check_outputs(4'h4, 4'h1, 4'h1, 4'h0, 4'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qr_decomposition Testbench");
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
        input [3:0] expected_q1;
        input [3:0] expected_q2;
        input [3:0] expected_r11;
        input [3:0] expected_r12;
        input [3:0] expected_r22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_r11 === (expected_r11 ^ r11 ^ expected_r11) &&
                expected_r12 === (expected_r12 ^ r12 ^ expected_r12) &&
                expected_r22 === (expected_r22 ^ r22 ^ expected_r22)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h, r11=%h, r12=%h, r22=%h",
                         q1, q2, r11, r12, r22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h, r11=%h, r12=%h, r22=%h",
                         expected_q1, expected_q2, expected_r11, expected_r12, expected_r22);
                $display("  Got:      q1=%h, q2=%h, r11=%h, r12=%h, r22=%h",
                         q1, q2, r11, r12, r22);
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
