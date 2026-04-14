`timescale 1ns/1ps

module matrix_inversion_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] a_inv;
    wire [31:0] b_inv;
    wire [31:0] c_inv;
    wire [31:0] d_inv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inversion dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .a_inv(a_inv),
        .b_inv(b_inv),
        .c_inv(c_inv),
        .d_inv(d_inv)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);

            a = 32'h00000001; b = 32'h00000000;
            c = 32'h00000000; d = 32'h00000001;

            #1;


            check_outputs(32'h00000001, 32'h00000000, 32'h00000000, 32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = 1", test_num);

            a = 32'h00000002; b = 32'h00000001;
            c = 32'h00000001; d = 32'h00000001;


            #1;



            check_outputs(32'h00000001, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = -1", test_num);

            a = 32'h00000001; b = 32'h00000002;
            c = 32'h00000001; d = 32'h00000001;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000002, 32'h00000001, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Singular Matrix (Det = 0)", test_num);

            a = 32'h00000001; b = 32'h00000001;
            c = 32'h00000001; d = 32'h00000001;

            #1;


            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matrix with negative values, Det = 1", test_num);

            a = 32'hFFFFFFFF; b = 32'hFFFFFFFE;
            c = 32'h00000001; d = 32'h00000001;

            #1;


            check_outputs(32'h00000001, 32'h00000002, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant = -1 with large values", test_num);

            a = 32'h00000005; b = 32'h00000002;
            c = 32'h00000003; d = 32'h00000001;


            #1;



            check_outputs(32'hFFFFFFFF, 32'h00000002, 32'h00000003, 32'hFFFFFFFB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inversion Testbench");
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
        input [31:0] expected_a_inv;
        input [31:0] expected_b_inv;
        input [31:0] expected_c_inv;
        input [31:0] expected_d_inv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_inv === (expected_a_inv ^ a_inv ^ expected_a_inv) &&
                expected_b_inv === (expected_b_inv ^ b_inv ^ expected_b_inv) &&
                expected_c_inv === (expected_c_inv ^ c_inv ^ expected_c_inv) &&
                expected_d_inv === (expected_d_inv ^ d_inv ^ expected_d_inv)) begin
                $display("PASS");
                $display("  Outputs: a_inv=%h, b_inv=%h, c_inv=%h, d_inv=%h",
                         a_inv, b_inv, c_inv, d_inv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_inv=%h, b_inv=%h, c_inv=%h, d_inv=%h",
                         expected_a_inv, expected_b_inv, expected_c_inv, expected_d_inv);
                $display("  Got:      a_inv=%h, b_inv=%h, c_inv=%h, d_inv=%h",
                         a_inv, b_inv, c_inv, d_inv);
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
