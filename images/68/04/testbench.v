`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in0_im;
    reg [15:0] in0_re;
    wire [1:0] out0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0_im(in0_im),
        .in0_re(in0_re),
        .out0(out0)
    );
    task testcase001;

        begin
            test_num = 1;
            in0_re = 16'h1000;
            in0_im = 16'h1000;
            $display("Test %0d: Quadrant 1 (Positive/Positive)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0_re = 16'hF000;
            in0_im = 16'h1000;
            $display("Test %0d: Quadrant 2 (Negative/Positive)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0_re = 16'hF000;
            in0_im = 16'hF000;
            $display("Test %0d: Quadrant 3 (Negative/Negative)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0_re = 16'h1000;
            in0_im = 16'hF000;
            $display("Test %0d: Quadrant 4 (Positive/Negative)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0_re = 16'h0000;
            in0_im = 16'h0000;
            $display("Test %0d: Origin Case (0,0)", test_num);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0_re = 16'h7FFF;
            in0_im = 16'h7FFF;
            $display("Test %0d: Max Positive Values", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0_re = 16'h8000;
            in0_im = 16'h8000;
            $display("Test %0d: Max Negative Values", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0_re = 16'hFFFF;
            in0_im = 16'h0001;
            $display("Test %0d: Small Magnitude (Negative/Positive)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in0_re = 16'h2000;
            in0_im = 16'h0000;
            $display("Test %0d: Positive Real Axis", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in0_re = 16'h0000;
            in0_im = 16'hE000;
            $display("Test %0d: Negative Imaginary Axis", test_num);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_out0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0)) begin
                $display("PASS");
                $display("  Outputs: out0=%h",
                         out0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h",
                         expected_out0);
                $display("  Got:      out0=%h",
                         out0);
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
