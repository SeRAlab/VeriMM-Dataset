`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Sel;
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] resultado;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sel(Sel),
        .a(a),
        .b(b),
        .resultado(resultado)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Simple (5 + 10)", test_num);
            Sel = 1'b1;
            a = 8'd5;
            b = 8'd10;
            #1;

            check_outputs(9'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Zero case (0 + 0)", test_num);
            Sel = 1'b1;
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Maximum result (255 + 255)", test_num);
            Sel = 1'b1;
            a = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition - Overflowing 8-bits (255 + 1)", test_num);
            Sel = 1'b1;
            a = 8'd255;
            b = 8'd1;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Simple (20 - 5)", test_num);
            Sel = 1'b0;
            a = 8'd20;
            b = 8'd5;
            #1;

            check_outputs(9'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Zero result (100 - 100)", test_num);
            Sel = 1'b0;
            a = 8'd100;
            b = 8'd100;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Negative result (underflow wrap-around) (5 - 10)", test_num);

            Sel = 1'b0;
            a = 8'd5;
            b = 8'd10;
            #1;

            check_outputs(9'd507);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction - Edge underflow (0 - 1)", test_num);

            Sel = 1'b0;
            a = 8'd0;
            b = 8'd1;
            #1;

            check_outputs(9'd511);
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
        input [8:0] expected_resultado;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultado === (expected_resultado ^ resultado ^ expected_resultado)) begin
                $display("PASS");
                $display("  Outputs: resultado=%h",
                         resultado);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultado=%h",
                         expected_resultado);
                $display("  Got:      resultado=%h",
                         resultado);
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
