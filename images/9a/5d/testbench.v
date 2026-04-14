`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_a;
    reg [15:0] data_b;
    wire neg;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_a(data_a),
        .data_b(data_b),
        .neg(neg),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplying by zero", test_num);
            data_a = 16'h0000;
            data_b = 16'h1234;

            #1;


            check_outputs(1'b0, 32'h00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both zero", test_num);
            data_a = 16'h0000;
            data_b = 16'h0000;

            #1;


            check_outputs(1'b0, 32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Positive", test_num);
            data_a = 16'd100;
            data_b = 16'd250;

            #1;


            check_outputs(1'b0, 32'h000061A8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Negative", test_num);
            data_a = 16'd50;
            data_b = -16'd10;

            #1;


            check_outputs(1'b1, 32'hFFFFFE0C, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Positive", test_num);
            data_a = -16'd1000;
            data_b = 16'd5;

            #1;


            check_outputs(1'b1, 32'hFFFFEC78, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Negative", test_num);
            data_a = -16'd12;
            data_b = -16'd12;

            #1;


            check_outputs(1'b0, 32'h00000090, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Positive * Maximum Positive", test_num);
            data_a = 16'h7FFF;
            data_b = 16'h7FFF;

            #1;


            check_outputs(1'b0, 32'h3FFF0001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Negative * Minimum Negative", test_num);
            data_a = 16'h8000;
            data_b = 16'h8000;

            #1;


            check_outputs(1'b0, 32'h40000000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Negative * Maximum Positive", test_num);
            data_a = 16'h8000;
            data_b = 16'h7FFF;

            #1;


            check_outputs(1'b1, 32'hC0008000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by -1", test_num);
            data_a = 16'h0001;
            data_b = 16'hFFFF;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF, 1'b0);
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
        testcase010();
        
        
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
        input expected_neg;
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_neg === (expected_neg ^ neg ^ expected_neg) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: neg=%b, out=%h, zero=%b",
                         neg, out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: neg=%b, out=%h, zero=%b",
                         expected_neg, expected_out, expected_zero);
                $display("  Got:      neg=%b, out=%h, zero=%b",
                         neg, out, zero);
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
