`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
    wire [7:0] inv11;
    wire [7:0] inv12;
    wire [7:0] inv21;
    wire [7:0] inv22;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .inv11(inv11),
        .inv12(inv12),
        .inv21(inv21),
        .inv22(inv22),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);


            a11 = 8'd1; a12 = 8'd0;
            a21 = 8'd0; a22 = 8'd1;
            #1;

            check_outputs(8'd1, 8'd0, 8'd0, 8'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant Zero (All same)", test_num);


            a11 = 8'd2; a12 = 8'd2;
            a21 = 8'd2; a22 = 8'd2;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant 1 (Integer Inverse)", test_num);


            a11 = 8'd5; a12 = 8'd2;
            a21 = 8'd2; a22 = 8'd1;

            #1;


            check_outputs(8'd1, 8'hFE, 8'hFE, 8'd5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant -1 (Integer Inverse)", test_num);


            a11 = 8'd2; a12 = 8'd5;
            a21 = 8'd1; a22 = 8'd2;

            #1;


            check_outputs(8'hFE, 8'd5, 8'd1, 8'hFE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swap Matrix (Det -1)", test_num);


            a11 = 8'd0; a12 = 8'd1;
            a21 = 8'd1; a22 = 8'd0;
            #1;

            check_outputs(8'd0, 8'd1, 8'd1, 8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant Zero (Linear Dependency)", test_num);


            a11 = 8'd1; a12 = 8'd2;
            a21 = 8'd2; a22 = 8'd4;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Matrix with 3 and 5 (Det 1)", test_num);


            a11 = 8'd3; a12 = 8'd5;
            a21 = 8'd1; a22 = 8'd2;

            #1;


            check_outputs(8'd2, 8'hFB, 8'hFF, 8'd3, 1'b1);
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
        input [7:0] expected_inv11;
        input [7:0] expected_inv12;
        input [7:0] expected_inv21;
        input [7:0] expected_inv22;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv11 === (expected_inv11 ^ inv11 ^ expected_inv11) &&
                expected_inv12 === (expected_inv12 ^ inv12 ^ expected_inv12) &&
                expected_inv21 === (expected_inv21 ^ inv21 ^ expected_inv21) &&
                expected_inv22 === (expected_inv22 ^ inv22 ^ expected_inv22) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: inv11=%h, inv12=%h, inv21=%h, inv22=%h, valid=%b",
                         inv11, inv12, inv21, inv22, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv11=%h, inv12=%h, inv21=%h, inv22=%h, valid=%b",
                         expected_inv11, expected_inv12, expected_inv21, expected_inv22, expected_valid);
                $display("  Got:      inv11=%h, inv12=%h, inv21=%h, inv22=%h, valid=%b",
                         inv11, inv12, inv21, inv22, valid);
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
