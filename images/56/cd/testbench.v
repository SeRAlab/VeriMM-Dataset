`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire [6:0] out_and;
    wire [6:0] out_sum;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .out_and(out_and),
        .out_sum(out_sum),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'h00;
            #1;

            check_outputs(7'h00, 7'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'hFF;



            #1;




            check_outputs(7'h7F, 7'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hAA;



            #1;




            check_outputs(7'h00, 7'h7E, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'h0F;



            #1;




            check_outputs(7'h07, 7'h10, 8'h88);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'hF0;



            #1;




            check_outputs(7'h70, 7'h10, 8'h88);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h01;



            #1;




            check_outputs(7'h00, 7'h02, 8'h81);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'hC3;



            #1;




            check_outputs(7'h41, 7'h02, 8'h02);
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
        input [6:0] expected_out_and;
        input [6:0] expected_out_sum;
        input [7:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_sum=%h, out_xor=%h",
                         out_and, out_sum, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_sum=%h, out_xor=%h",
                         expected_out_and, expected_out_sum, expected_out_xor);
                $display("  Got:      out_and=%h, out_sum=%h, out_xor=%h",
                         out_and, out_sum, out_xor);
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
