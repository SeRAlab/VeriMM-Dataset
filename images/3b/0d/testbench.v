`timescale 1ns/1ps

module matrix_inverse_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    wire [15:0] inv11;
    wire [15:0] inv12;
    wire [15:0] inv21;
    wire [15:0] inv22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse_2x2 dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .inv11(inv11),
        .inv12(inv12),
        .inv21(inv21),
        .inv22(inv22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Matrix", test_num);
            a11 = 16'h0001; a12 = 16'h0000;
            a21 = 16'h0000; a22 = 16'h0001;
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Determinant 1", test_num);
            a11 = 16'h0002; a12 = 16'h0001;
            a21 = 16'h0001; a22 = 16'h0001;
            #1;

            check_outputs(16'h0001, 16'hFFFF, 16'hFFFF, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Determinant -1", test_num);
            a11 = 16'h0001; a12 = 16'h0002;
            a21 = 16'h0001; a22 = 16'h0001;
            #1;

            check_outputs(16'hFFFF, 16'h0002, 16'h0001, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Permutation Matrix (Zeros)", test_num);
            a11 = 16'h0000; a12 = 16'h0001;
            a21 = 16'h0001; a22 = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0001, 16'h0001, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Elements", test_num);
            a11 = 16'hFFFF; a12 = 16'h0000;
            a21 = 16'h0000; a22 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'h0000, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Larger Values", test_num);
            a11 = 16'h0003; a12 = 16'h0005;
            a21 = 16'h0001; a22 = 16'h0002;
            #1;

            check_outputs(16'h0002, 16'hFFFB, 16'hFFFF, 16'h0003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Determinant -1 with scaling", test_num);
            a11 = 16'h0002; a12 = 16'h0005;
            a21 = 16'h0001; a22 = 16'h0002;
            #1;

            check_outputs(16'hFFFE, 16'h0005, 16'h0001, 16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse_2x2 Testbench");
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
        input [15:0] expected_inv11;
        input [15:0] expected_inv12;
        input [15:0] expected_inv21;
        input [15:0] expected_inv22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv11 === (expected_inv11 ^ inv11 ^ expected_inv11) &&
                expected_inv12 === (expected_inv12 ^ inv12 ^ expected_inv12) &&
                expected_inv21 === (expected_inv21 ^ inv21 ^ expected_inv21) &&
                expected_inv22 === (expected_inv22 ^ inv22 ^ expected_inv22)) begin
                $display("PASS");
                $display("  Outputs: inv11=%h, inv12=%h, inv21=%h, inv22=%h",
                         inv11, inv12, inv21, inv22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv11=%h, inv12=%h, inv21=%h, inv22=%h",
                         expected_inv11, expected_inv12, expected_inv21, expected_inv22);
                $display("  Got:      inv11=%h, inv12=%h, inv21=%h, inv22=%h",
                         inv11, inv12, inv21, inv22);
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
