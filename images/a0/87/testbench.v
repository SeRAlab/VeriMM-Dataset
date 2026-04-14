`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [4:0] shift;
    wire [31:0] out_a;
    wire [31:0] out_l;
    wire [31:0] out_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift(shift),
        .out_a(out_a),
        .out_l(out_l),
        .out_r(out_r)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Shift by 0", test_num);
            in = 32'h12345678;
            shift = 5'd0;
            #1;

            check_outputs(32'h12345678, 32'h12345678, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Simple Logical Left Shift", test_num);
            in = 32'h00000001;
            shift = 5'd4;

            #1;


            check_outputs(32'h00000000, 32'h00000010, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Arithmetic Right Shift (Sign Extension)", test_num);
            in = 32'h80000000;
            shift = 5'd1;



            #1;




            check_outputs(32'hC0000000, 32'h00000000, 32'h40000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Maximum Shift (31 bits)", test_num);
            in = 32'hFFFFFFFF;
            shift = 5'd31;



            #1;




            check_outputs(32'hFFFFFFFF, 32'h80000000, 32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Pattern Shift (Alternating bits)", test_num);
            in = 32'hAAAAAAAA;
            shift = 5'd8;



            #1;




            check_outputs(32'hFFAAAAAA, 32'hAAAAAA00, 32'h00AAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Arithmetic Right Shift (Positive Value)", test_num);
            in = 32'h7FFFFFFF;
            shift = 5'd4;



            #1;




            check_outputs(32'h07FFFFFF, 32'hFFFFFFF0, 32'h07FFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Zero Input", test_num);
            in = 32'h00000000;
            shift = 5'd16;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Mid-range shift (16 bits)", test_num);
            in = 32'hABCD1234;
            shift = 5'd16;



            #1;




            check_outputs(32'hFFFFABCD, 32'h12340000, 32'h0000ABCD);
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
        input [31:0] expected_out_a;
        input [31:0] expected_out_l;
        input [31:0] expected_out_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_a === (expected_out_a ^ out_a ^ expected_out_a) &&
                expected_out_l === (expected_out_l ^ out_l ^ expected_out_l) &&
                expected_out_r === (expected_out_r ^ out_r ^ expected_out_r)) begin
                $display("PASS");
                $display("  Outputs: out_a=%h, out_l=%h, out_r=%h",
                         out_a, out_l, out_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_a=%h, out_l=%h, out_r=%h",
                         expected_out_a, expected_out_l, expected_out_r);
                $display("  Got:      out_a=%h, out_l=%h, out_r=%h",
                         out_a, out_l, out_r);
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
