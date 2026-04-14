`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_a;
    reg [7:0] i_b;
    wire o_bit_and;
    wire o_bit_not;
    wire o_bit_or;
    wire o_bit_xnor;
    wire o_bit_xor;
    wire [7:0] o_bits_and;
    wire [7:0] o_bits_not;
    wire [7:0] o_bits_or;
    wire [7:0] o_bits_xnor;
    wire [7:0] o_bits_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_b(i_b),
        .o_bit_and(o_bit_and),
        .o_bit_not(o_bit_not),
        .o_bit_or(o_bit_or),
        .o_bit_xnor(o_bit_xnor),
        .o_bit_xor(o_bit_xor),
        .o_bits_and(o_bits_and),
        .o_bits_not(o_bits_not),
        .o_bits_or(o_bits_or),
        .o_bits_xnor(o_bits_xnor),
        .o_bits_xor(o_bits_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            i_a = 8'h00;
            i_b = 8'h00;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 8'h00, 8'hFF, 8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            i_a = 8'hFF;
            i_b = 8'hFF;



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            i_a = 8'hAA;
            i_b = 8'h55;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 8'h00, 8'h55, 8'hFF, 8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            i_a = 8'hCC;
            i_b = 8'hF0;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 8'hC0, 8'h33, 8'hFC, 8'hC3, 8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            i_a = 8'h01;
            i_b = 8'h01;



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 8'h01, 8'hFE, 8'h01, 8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            i_a = 8'hA5;
            i_b = 8'h5A;



            #1;




            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 8'h00, 8'h5A, 8'hFF, 8'h00, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            i_a = 8'h81;
            i_b = 8'h7E;



            #1;




            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 8'h00, 8'h7E, 8'hFF, 8'h00, 8'hFF);
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
        input expected_o_bit_and;
        input expected_o_bit_not;
        input expected_o_bit_or;
        input expected_o_bit_xnor;
        input expected_o_bit_xor;
        input [7:0] expected_o_bits_and;
        input [7:0] expected_o_bits_not;
        input [7:0] expected_o_bits_or;
        input [7:0] expected_o_bits_xnor;
        input [7:0] expected_o_bits_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_bit_and === (expected_o_bit_and ^ o_bit_and ^ expected_o_bit_and) &&
                expected_o_bit_not === (expected_o_bit_not ^ o_bit_not ^ expected_o_bit_not) &&
                expected_o_bit_or === (expected_o_bit_or ^ o_bit_or ^ expected_o_bit_or) &&
                expected_o_bit_xnor === (expected_o_bit_xnor ^ o_bit_xnor ^ expected_o_bit_xnor) &&
                expected_o_bit_xor === (expected_o_bit_xor ^ o_bit_xor ^ expected_o_bit_xor) &&
                expected_o_bits_and === (expected_o_bits_and ^ o_bits_and ^ expected_o_bits_and) &&
                expected_o_bits_not === (expected_o_bits_not ^ o_bits_not ^ expected_o_bits_not) &&
                expected_o_bits_or === (expected_o_bits_or ^ o_bits_or ^ expected_o_bits_or) &&
                expected_o_bits_xnor === (expected_o_bits_xnor ^ o_bits_xnor ^ expected_o_bits_xnor) &&
                expected_o_bits_xor === (expected_o_bits_xor ^ o_bits_xor ^ expected_o_bits_xor)) begin
                $display("PASS");
                $display("  Outputs: o_bit_and=%b, o_bit_not=%b, o_bit_or=%b, o_bit_xnor=%b, o_bit_xor=%b, o_bits_and=%h, o_bits_not=%h, o_bits_or=%h, o_bits_xnor=%h, o_bits_xor=%h",
                         o_bit_and, o_bit_not, o_bit_or, o_bit_xnor, o_bit_xor, o_bits_and, o_bits_not, o_bits_or, o_bits_xnor, o_bits_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_bit_and=%b, o_bit_not=%b, o_bit_or=%b, o_bit_xnor=%b, o_bit_xor=%b, o_bits_and=%h, o_bits_not=%h, o_bits_or=%h, o_bits_xnor=%h, o_bits_xor=%h",
                         expected_o_bit_and, expected_o_bit_not, expected_o_bit_or, expected_o_bit_xnor, expected_o_bit_xor, expected_o_bits_and, expected_o_bits_not, expected_o_bits_or, expected_o_bits_xnor, expected_o_bits_xor);
                $display("  Got:      o_bit_and=%b, o_bit_not=%b, o_bit_or=%b, o_bit_xnor=%b, o_bit_xor=%b, o_bits_and=%h, o_bits_not=%h, o_bits_or=%h, o_bits_xnor=%h, o_bits_xor=%h",
                         o_bit_and, o_bit_not, o_bit_or, o_bit_xnor, o_bit_xor, o_bits_and, o_bits_not, o_bits_or, o_bits_xnor, o_bits_xor);
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
