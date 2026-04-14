`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    wire [15:0] inv11;
    wire [15:0] inv12;
    wire [15:0] inv21;
    wire [15:0] inv22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .inv11(inv11),
        .inv12(inv12),
        .inv21(inv21),
        .inv22(inv22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            a = 16'h0001; b = 16'h0000;
            c = 16'h0000; d = 16'h0001;
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Singular Matrix (ad-bc=0)", test_num);
            a = 16'h0001; b = 16'h0002;
            c = 16'h0002; d = 16'h0004;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with det=1", test_num);
            a = 16'h0005; b = 16'h0002;
            c = 16'h0002; d = 16'h0001;
            #1;

            check_outputs(16'h0001, 16'hFFFE, 16'hFFFE, 16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with det=-1", test_num);
            a = 16'h0001; b = 16'h0002;
            c = 16'h0001; d = 16'h0001;
            #1;

            check_outputs(16'hFFFF, 16'h0002, 16'h0001, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zero Matrix", test_num);
            a = 16'h0000; b = 16'h0000;
            c = 16'h0000; d = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linearly Dependent Rows", test_num);
            a = 16'h0003; b = 16'h0006;
            c = 16'h0001; d = 16'h0002;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger values with det=1", test_num);
            a = 16'h000D; b = 16'h0005;
            c = 16'h0005; d = 16'h0002;
            #1;

            check_outputs(16'h0002, 16'hFFFB, 16'hFFFB, 16'h000D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
