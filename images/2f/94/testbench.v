`timescale 1ns/1ps

module conv2d_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [26:0] input_matrix;
    reg [26:0] kernel;
    wire [8:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv2d_3x3 dut (
        .input_matrix(input_matrix),
        .kernel(kernel),
        .output_value(output_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            input_matrix = 27'h0;
            kernel = 27'h0;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Elements Only", test_num);

            input_matrix = 27'b000_000_000_000_101_000_000_000_000;

            kernel       = 27'b000_000_000_000_010_000_000_000_000;
            #1;

            check_outputs(9'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);

            input_matrix = 27'o111111111;
            kernel       = 27'o111111111;
            #1;

            check_outputs(9'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values (7*7*9)", test_num);

            input_matrix = 27'o777777777;
            kernel       = 27'o777777777;
            #1;

            check_outputs(9'd441);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Sum of Products", test_num);
            input_matrix = {3'd1, 3'd2, 3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
            kernel       = {3'd2, 3'd1, 3'd4, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
            #1;

            check_outputs(9'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Weights", test_num);
            input_matrix = 27'o111111111;
            kernel       = 27'o707070707;
            #1;

            check_outputs(9'd35);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv2d_3x3 Testbench");
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
        input [8:0] expected_output_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
