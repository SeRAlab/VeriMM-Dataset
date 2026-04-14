`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [4:0] shift_amount;
    wire [15:0] final_output;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .shift_amount(shift_amount),
        .final_output(final_output),
        .zero_flag(zero_flag)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition, shift 0", test_num);
            a = 8'd10; b = 8'd20; shift_amount = 5'b00000;

            #1;


            check_outputs(16'h001E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed overflow (127 + 1)", test_num);
            a = 8'd127; b = 8'd1; shift_amount = 5'b00000;

            #1;


            check_outputs(16'h8080, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed overflow (-128 + -1)", test_num);
            a = 8'h80; b = 8'hFF; shift_amount = 5'b00000;

            #1;


            check_outputs(16'h807F, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Left (sum 5 << 3)", test_num);
            a = 8'd2; b = 8'd3; shift_amount = 5'b00011;

            #1;


            check_outputs(16'h0028, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right (sum 64 >> 2)", test_num);
            a = 8'd64; b = 8'd0; shift_amount = 5'b10010;

            #1;


            check_outputs(16'h0010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero sum check", test_num);
            a = 8'd50; b = -8'd50; shift_amount = 5'b00000;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift right to zero", test_num);
            a = 8'd1; b = 8'd0; shift_amount = 5'b10001;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max shift left (0xFF << 7)", test_num);
            a = 8'hFF; b = 8'h00; shift_amount = 5'b00111;

            #1;


            check_outputs(16'h7F80, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -128 + -128 overflow", test_num);
            a = 8'h80; b = 8'h80; shift_amount = 5'b00000;

            #1;


            check_outputs(16'h8000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_final_output;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, zero_flag=%b",
                         final_output, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, zero_flag=%b",
                         expected_final_output, expected_zero_flag);
                $display("  Got:      final_output=%h, zero_flag=%b",
                         final_output, zero_flag);
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
