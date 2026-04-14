`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] inv_a;
    wire [31:0] inv_b;
    wire [31:0] inv_c;
    wire [31:0] inv_d;
    wire valid;

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
        .inv_d(inv_d),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            a = 32'd1; b = 32'd0;
            c = 32'd0; d = 32'd1;

            #1;


            check_outputs(32'd1, 32'd0, 32'd0, 32'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Non-invertible Matrix (All Zeros)", test_num);
            a = 32'd0; b = 32'd0;
            c = 32'd0; d = 32'd0;

            #1;


            check_outputs(32'd0, 32'd0, 32'd0, 32'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant = 1, Upper Triangular", test_num);
            a = 32'd1; b = 32'd2;
            c = 32'd0; d = 32'd1;

            #1;


            check_outputs(32'd1, 32'hFFFFFFFE, 32'd0, 32'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Determinant = -1", test_num);
            a = 32'd1; b = 32'd2;
            c = 32'd1; d = 32'd1;





            #1;






            check_outputs(32'hFFFFFFFF, 32'd2, 32'd1, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Non-invertible (Linear Dependency)", test_num);
            a = 32'd2; b = 32'd4;
            c = 32'd1; d = 32'd2;

            #1;


            check_outputs(32'd0, 32'd0, 32'd0, 32'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Swapping and Signs", test_num);
            a = 32'd0; b = 32'd1;
            c = 32'hFFFFFFFF; d = 32'd0;





            #1;






            check_outputs(32'd0, 32'hFFFFFFFF, 32'd1, 32'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integer Matrix with Det = 1", test_num);
            a = 32'd3; b = 32'd2;
            c = 32'd4; d = 32'd3;


            #1;



            check_outputs(32'd3, 32'hFFFFFFFE, 32'hFFFFFFFC, 32'd3, 1'b1);
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
        input [31:0] expected_inv_a;
        input [31:0] expected_inv_b;
        input [31:0] expected_inv_c;
        input [31:0] expected_inv_d;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv_a === (expected_inv_a ^ inv_a ^ expected_inv_a) &&
                expected_inv_b === (expected_inv_b ^ inv_b ^ expected_inv_b) &&
                expected_inv_c === (expected_inv_c ^ inv_c ^ expected_inv_c) &&
                expected_inv_d === (expected_inv_d ^ inv_d ^ expected_inv_d) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         inv_a, inv_b, inv_c, inv_d, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         expected_inv_a, expected_inv_b, expected_inv_c, expected_inv_d, expected_valid);
                $display("  Got:      inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         inv_a, inv_b, inv_c, inv_d, valid);
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
