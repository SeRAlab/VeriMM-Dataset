`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [15:0] inv_a;
    wire [15:0] inv_b;
    wire [15:0] inv_c;
    wire [15:0] inv_d;

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
        .inv_a(inv_a),
        .inv_b(inv_b),
        .inv_c(inv_c),
        .inv_d(inv_d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            a = 8'd1; b = 8'd0; c = 8'd0; d = 8'd1;
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Matrix (Non-invertible)", test_num);
            a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = 1", test_num);
            a = 8'd2; b = 8'd1; c = 8'd1; d = 8'd1;
            #1;

            check_outputs(16'h0001, 16'hFFFF, 16'hFFFF, 16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Singular Matrix (Dependent Rows)", test_num);
            a = 8'd2; b = 8'd4; c = 8'd1; d = 8'd2;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = -1", test_num);
            a = 8'd1; b = 8'd2; c = 8'd1; d = 8'd1;
            #1;

            check_outputs(16'hFFFF, 16'h0002, 16'h0001, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = 1 (Large Values)", test_num);
            a = 8'd3; b = 8'd5; c = 8'd1; d = 8'd2;
            #1;

            check_outputs(16'h0002, 16'hFFFB, 16'hFFFF, 16'h0003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = -1 (With Zeros)", test_num);
            a = 8'd1; b = 8'd1; c = 8'd1; d = 8'd0;
            #1;

            check_outputs(16'h0000, 16'h0001, 16'h0001, 16'hFFFF);
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
        input [15:0] expected_inv_a;
        input [15:0] expected_inv_b;
        input [15:0] expected_inv_c;
        input [15:0] expected_inv_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv_a === (expected_inv_a ^ inv_a ^ expected_inv_a) &&
                expected_inv_b === (expected_inv_b ^ inv_b ^ expected_inv_b) &&
                expected_inv_c === (expected_inv_c ^ inv_c ^ expected_inv_c) &&
                expected_inv_d === (expected_inv_d ^ inv_d ^ expected_inv_d)) begin
                $display("PASS");
                $display("  Outputs: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         inv_a, inv_b, inv_c, inv_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         expected_inv_a, expected_inv_b, expected_inv_c, expected_inv_d);
                $display("  Got:      inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         inv_a, inv_b, inv_c, inv_d);
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
