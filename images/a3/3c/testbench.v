`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_i;
    reg [3:0] in_q;
    wire [3:0] out_i;
    wire [3:0] out_q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_i(in_i),
        .in_q(in_q),
        .out_i(out_i),
        .out_q(out_q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros", test_num);
            in_i = 4'd0;
            in_q = 4'd0;


            #1;



            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Small Positive Inputs", test_num);
            in_i = 4'd2;
            in_q = 4'd1;

            #1;


            check_outputs(4'h2, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Small Negative Inputs", test_num);
            in_i = -4'd2;
            in_q = -4'd3;
            #1;

            check_outputs(4'hE, 4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum Positive Range", test_num);
            in_i = 4'd7;
            in_q = 4'd7;
            #1;

            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Minimum Negative Range", test_num);
            in_i = -4'd8;
            in_q = -4'd8;
            #1;

            check_outputs(4'h8, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mixed Sign Impulse I", test_num);
            in_i = 4'd5;
            in_q = -4'd5;
            #1;

            check_outputs(4'h5, 4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Asymmetric Inputs", test_num);
            in_i = 4'd3;
            in_q = 4'd0;
            #1;

            check_outputs(4'h3, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Quadrature Impulse", test_num);
            in_i = 4'd0;
            in_q = 4'd4;
            #1;

            check_outputs(4'h0, 4'h4);
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
        input [3:0] expected_out_i;
        input [3:0] expected_out_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_i === (expected_out_i ^ out_i ^ expected_out_i) &&
                expected_out_q === (expected_out_q ^ out_q ^ expected_out_q)) begin
                $display("PASS");
                $display("  Outputs: out_i=%h, out_q=%h",
                         out_i, out_q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_i=%h, out_q=%h",
                         expected_out_i, expected_out_q);
                $display("  Got:      out_i=%h, out_q=%h",
                         out_i, out_q);
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
