`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg [1:0] c;
    reg [1:0] d;
    wire [1:0] q11;
    wire [1:0] q12;
    wire [1:0] r11;
    wire [1:0] r12;
    wire [1:0] r22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .q11(q11),
        .q12(q12),
        .r11(r11),
        .r12(r12),
        .r22(r22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            a = 2'd1; b = 2'd0; c = 2'd0; d = 2'd1;
            #1;

            check_outputs(2'd1, 2'd0, 2'd1, 2'd0, 2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scalar Matrix", test_num);
            a = 2'd2; b = 2'd0; c = 2'd0; d = 2'd2;
            #1;

            check_outputs(2'd1, 2'd0, 2'd2, 2'd0, 2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Triangular Matrix", test_num);
            a = 2'd1; b = 2'd1; c = 2'd0; d = 2'd1;
            #1;

            check_outputs(2'd1, 2'd0, 2'd1, 2'd1, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Permutation Matrix", test_num);
            a = 2'd0; b = 2'd1; c = 2'd1; d = 2'd0;
            #1;

            check_outputs(2'd0, 2'd1, 2'd1, 2'd0, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scaled Permutation Matrix", test_num);
            a = 2'd0; b = 2'd2; c = 2'd2; d = 2'd0;
            #1;

            check_outputs(2'd0, 2'd1, 2'd2, 2'd0, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Matrix", test_num);
            a = 2'd0; b = 2'd0; c = 2'd0; d = 2'd0;
            #1;

            check_outputs(2'd0, 2'd0, 2'd0, 2'd0, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with a=3", test_num);
            a = 2'd3; b = 2'd1; c = 2'd0; d = 2'd2;
            #1;

            check_outputs(2'd1, 2'd0, 2'd3, 2'd1, 2'd2);
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
        input [1:0] expected_q11;
        input [1:0] expected_q12;
        input [1:0] expected_r11;
        input [1:0] expected_r12;
        input [1:0] expected_r22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q11 === (expected_q11 ^ q11 ^ expected_q11) &&
                expected_q12 === (expected_q12 ^ q12 ^ expected_q12) &&
                expected_r11 === (expected_r11 ^ r11 ^ expected_r11) &&
                expected_r12 === (expected_r12 ^ r12 ^ expected_r12) &&
                expected_r22 === (expected_r22 ^ r22 ^ expected_r22)) begin
                $display("PASS");
                $display("  Outputs: q11=%h, q12=%h, r11=%h, r12=%h, r22=%h",
                         q11, q12, r11, r12, r22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q11=%h, q12=%h, r11=%h, r12=%h, r22=%h",
                         expected_q11, expected_q12, expected_r11, expected_r12, expected_r22);
                $display("  Got:      q11=%h, q12=%h, r11=%h, r12=%h, r22=%h",
                         q11, q12, r11, r12, r22);
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
