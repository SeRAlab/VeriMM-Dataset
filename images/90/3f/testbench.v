`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [3:0] in;
    wire out_final;
    wire out_nand;
    wire out_nor;
    wire [5:0] out_not;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;
    wire out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .in(in),
        .out_final(out_final),
        .out_nand(out_nand),
        .out_nor(out_nor),
        .out_not(out_not),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .out_xnor(out_xnor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 4'b0000;
            a = 3'b000;
            b = 3'b000;








            #1;









            check_outputs(1'b1, 1'b1, 1'b1, 6'h3F, 3'b000, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 4'b1111;
            a = 3'b111;
            b = 3'b111;








            #1;









            check_outputs(1'b1, 1'b0, 1'b0, 6'h00, 3'b111, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 4'b1010;
            a = 3'b101;
            b = 3'b010;







            #1;








            check_outputs(1'b1, 1'b1, 1'b0, 6'h2A, 3'b111, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 4'b0001;
            a = 3'b001;
            b = 3'b100;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 6'h1E, 3'b101, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 4'b1110;
            a = 3'b011;
            b = 3'b110;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 6'h0C, 3'b111, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 4'b0111;
            a = 3'b000;
            b = 3'b000;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 6'h3F, 3'b000, 1'b0, 1'b0);
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
        input expected_out_final;
        input expected_out_nand;
        input expected_out_nor;
        input [5:0] expected_out_not;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        input expected_out_xnor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_final === (expected_out_final ^ out_final ^ expected_out_final) &&
                expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_final=%b, out_nand=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b, out_xnor=%b",
                         out_final, out_nand, out_nor, out_not, out_or_bitwise, out_or_logical, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_final=%b, out_nand=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b, out_xnor=%b",
                         expected_out_final, expected_out_nand, expected_out_nor, expected_out_not, expected_out_or_bitwise, expected_out_or_logical, expected_out_xnor);
                $display("  Got:      out_final=%b, out_nand=%b, out_nor=%b, out_not=%h, out_or_bitwise=%h, out_or_logical=%b, out_xnor=%b",
                         out_final, out_nand, out_nor, out_not, out_or_bitwise, out_or_logical, out_xnor);
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
