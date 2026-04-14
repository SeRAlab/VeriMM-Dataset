`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in;
    wire [5:0] out_or;
    wire [5:0] out_sum;
    wire [6:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_or(out_or),
        .out_sum(out_sum),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 7'b000_0000;
            #10;
            $display("Test Case %0d: All Zeros", test_num);
            #1;

            check_outputs(6'h00, 6'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 7'b111_1111;
            #10;
            $display("Test Case %0d: All Ones", test_num);



            #1;




            check_outputs(6'h3F, 6'h3E, 7'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 7'b101_0101;
            #10;
            $display("Test Case %0d: Alternating 1010101", test_num);




            #1;





            check_outputs(6'h3F, 6'h3F, 7'h7E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 7'b010_1010;
            #10;
            $display("Test Case %0d: Alternating 0101010", test_num);




            #1;





            check_outputs(6'h3F, 6'h3F, 7'h7E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 7'b100_1001;
            #10;
            $display("Test Case %0d: Sparse Bits 1001001", test_num);




            #1;





            check_outputs(6'h2D, 6'h2D, 7'h5A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 7'b000_1100;
            #10;
            $display("Test Case %0d: Consecutive Ones 0001100", test_num);




            #1;





            check_outputs(6'h0E, 6'h12, 7'h14);
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
        input [5:0] expected_out_or;
        input [5:0] expected_out_sum;
        input [6:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or=%h, out_sum=%h, out_xor=%h",
                         expected_out_or, expected_out_sum, expected_out_xor);
                $display("  Got:      out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
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
