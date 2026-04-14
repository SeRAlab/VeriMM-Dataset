`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] in;
    wire out_even_bits;
    wire out_most_zeros;
    wire out_odd_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_even_bits(out_even_bits),
        .out_most_zeros(out_most_zeros),
        .out_odd_bits(out_odd_bits)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            in = 12'b0000_0000_0000;



            #1;




            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones", test_num);
            in = 12'b1111_1111_1111;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Alternating (Even=1, Odd=0)", test_num);
            in = 12'b0101_0101_0101;





            #1;






            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Alternating (Even=0, Odd=1)", test_num);
            in = 12'b1010_1010_1010;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Majority of zeros boundary (Exactly 6 zeros)", test_num);
            in = 12'b1111_1100_0000;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Majority of zeros boundary (Exactly 7 zeros)", test_num);
            in = 12'b1111_1000_0000;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Even bits all 1 except one bit", test_num);
            in = 12'b1111_1111_1110;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Odd bits all 0 except one bit", test_num);
            in = 12'b0000_0000_0010;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Random pattern check", test_num);
            in = 12'b0101_0111_0101;



            #1;




            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Odd bits all zero, even bits mixed", test_num);
            in = 12'b0100_0001_0001;




            #1;





            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_out_even_bits;
        input expected_out_most_zeros;
        input expected_out_odd_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_even_bits === (expected_out_even_bits ^ out_even_bits ^ expected_out_even_bits) &&
                expected_out_most_zeros === (expected_out_most_zeros ^ out_most_zeros ^ expected_out_most_zeros) &&
                expected_out_odd_bits === (expected_out_odd_bits ^ out_odd_bits ^ expected_out_odd_bits)) begin
                $display("PASS");
                $display("  Outputs: out_even_bits=%b, out_most_zeros=%b, out_odd_bits=%b",
                         out_even_bits, out_most_zeros, out_odd_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_even_bits=%b, out_most_zeros=%b, out_odd_bits=%b",
                         expected_out_even_bits, expected_out_most_zeros, expected_out_odd_bits);
                $display("  Got:      out_even_bits=%b, out_most_zeros=%b, out_odd_bits=%b",
                         out_even_bits, out_most_zeros, out_odd_bits);
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
