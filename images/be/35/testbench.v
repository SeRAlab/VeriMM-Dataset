`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in1;
    reg [6:0] in2;
    reg [6:0] in3;
    reg [6:0] in4;
    reg [6:0] in5;
    reg [6:0] in6;
    reg [6:0] in7;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            in1 = 7'b0000000;
            in2 = 7'b0000000;
            in3 = 7'b0000000;
            in4 = 7'b0000000;
            in5 = 7'b0000000;
            in6 = 7'b0000000;
            in7 = 7'b0000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs set to max value (all bits match)", test_num);
            in1 = 7'b1111111;
            in2 = 7'b1111111;
            in3 = 7'b1111111;
            in4 = 7'b1111111;
            in5 = 7'b1111111;
            in6 = 7'b1111111;
            in7 = 7'b1111111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only bit 0 matches across all inputs", test_num);
            in1 = 7'b0000001;
            in2 = 7'b0101011;
            in3 = 7'b1111111;
            in4 = 7'b0000011;
            in5 = 7'b1010101;
            in6 = 7'b0110111;
            in7 = 7'b0000001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only bit 6 matches across all inputs", test_num);
            in1 = 7'b1000000;
            in2 = 7'b1110000;
            in3 = 7'b1010101;
            in4 = 7'b1111111;
            in5 = 7'b1001001;
            in6 = 7'b1100110;
            in7 = 7'b1000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Six inputs match at bit 0, one does not", test_num);
            in1 = 7'b0000001;
            in2 = 7'b0000001;
            in3 = 7'b0000001;
            in4 = 7'b0000001;
            in5 = 7'b0000001;
            in6 = 7'b0000001;
            in7 = 7'b0000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scattered bits, no single position matches across all", test_num);
            in1 = 7'b0000001;
            in2 = 7'b0000010;
            in3 = 7'b0000100;
            in4 = 7'b0001000;
            in5 = 7'b0010000;
            in6 = 7'b0100000;
            in7 = 7'b1000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple bit positions match (bits 2 and 4)", test_num);
            in1 = 7'b0010100;
            in2 = 7'b0010100;
            in3 = 7'b1111111;
            in4 = 7'b0010111;
            in5 = 7'b1010101;
            in6 = 7'b0111110;
            in7 = 7'b0010100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs have values, but no bitwise overlap", test_num);
            in1 = 7'b1010101;
            in2 = 7'b0101010;
            in3 = 7'b1010101;
            in4 = 7'b0101010;
            in5 = 7'b1010101;
            in6 = 7'b0101010;
            in7 = 7'b1010101;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
