`timescale 1ns/1ps

module matrix_inversion_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] out_11;
    wire [3:0] out_12;
    wire [3:0] out_21;
    wire [3:0] out_22;

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
        .out_11(out_11),
        .out_12(out_12),
        .out_21(out_21),
        .out_22(out_22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            a = 4'h1; b = 4'h0; c = 4'h0; d = 4'h1;
            #1;

            check_outputs(4'h1, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Determinant (1s)", test_num);
            a = 4'h1; b = 4'h1; c = 4'h1; d = 4'h1;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Anti-Diagonal (Det = -1)", test_num);
            a = 4'h0; b = 4'h1; c = 4'h1; d = 4'h0;
            #1;

            check_outputs(4'h0, 4'h1, 4'h1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Values (Det = 1)", test_num);
            a = 4'h3; b = 4'h2; c = 4'h1; d = 4'h1;
            #1;

            check_outputs(4'h1, 4'hE, 4'hF, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Values (Det = -1)", test_num);
            a = 4'h1; b = 4'h2; c = 4'h1; d = 4'h1;
            #1;

            check_outputs(4'hF, 4'h2, 4'h1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Scaling Matrix (Integer Truncation)", test_num);
            a = 4'h2; b = 4'h0; c = 4'h0; d = 4'h2;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Input", test_num);
            a = 4'h0; b = 4'h0; c = 4'h0; d = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large elements (Det = 1)", test_num);
            a = 4'h7; b = 4'h6; c = 4'h1; d = 4'h1;
            #1;

            check_outputs(4'h1, 4'hA, 4'hF, 4'h7);
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
        input [3:0] expected_out_11;
        input [3:0] expected_out_12;
        input [3:0] expected_out_21;
        input [3:0] expected_out_22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_11 === (expected_out_11 ^ out_11 ^ expected_out_11) &&
                expected_out_12 === (expected_out_12 ^ out_12 ^ expected_out_12) &&
                expected_out_21 === (expected_out_21 ^ out_21 ^ expected_out_21) &&
                expected_out_22 === (expected_out_22 ^ out_22 ^ expected_out_22)) begin
                $display("PASS");
                $display("  Outputs: out_11=%h, out_12=%h, out_21=%h, out_22=%h",
                         out_11, out_12, out_21, out_22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_11=%h, out_12=%h, out_21=%h, out_22=%h",
                         expected_out_11, expected_out_12, expected_out_21, expected_out_22);
                $display("  Got:      out_11=%h, out_12=%h, out_21=%h, out_22=%h",
                         out_11, out_12, out_21, out_22);
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
