`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg signed_ctrl;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .signed_ctrl(signed_ctrl),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 0 * 0", test_num);
            a = 8'd0;
            b = 8'd0;
            signed_ctrl = 1'b0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Small Values (12 * 5)", test_num);
            a = 8'd12;
            b = 8'd5;
            signed_ctrl = 1'b0;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Max Values (255 * 255)", test_num);
            a = 8'd255;
            b = 8'd255;
            signed_ctrl = 1'b0;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Positive * Positive (10 * 10)", test_num);
            a = 8'sd10;
            b = 8'sd10;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(16'sd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Negative * Positive (-10 * 5)", test_num);
            a = -8'sd10;
            b = 8'sd5;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(-16'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Positive * Negative (5 * -10)", test_num);
            a = 8'sd5;
            b = -8'sd10;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(-16'sd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Negative * Negative (-5 * -10)", test_num);
            a = -8'sd5;
            b = -8'sd10;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Most Negative (-128 * -128)", test_num);
            a = -8'sd128;
            b = -8'sd128;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(16'sh4000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Most Negative * Positive (-128 * 127)", test_num);
            a = -8'sd128;
            b = 8'sd127;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(-16'sd16256);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Toggle (0xFF * 0xFF)", test_num);
            a = 8'hFF;
            b = 8'hFF;


            signed_ctrl = 1'b1;
            #1;

            check_outputs(16'sd1);


            #10;
            test_num = test_num + 1;
            $display("Testcase %0d: Control Toggle (255 * 255 unsigned)", test_num);
            signed_ctrl = 1'b0;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Zero Case (-128 * 0)", test_num);
            a = -8'sd128;
            b = 8'sd0;
            signed_ctrl = 1'b1;
            #1;

            check_outputs(16'd0);
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
        testcase011();
        
        
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
