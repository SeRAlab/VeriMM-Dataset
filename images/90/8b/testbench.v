`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_in;
    wire c_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .c_out(c_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            a = 4'b0000;
            b = 4'b0000;
            c_in = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition without carry", test_num);
            a = 4'h5;
            b = 4'h2;
            c_in = 1'b0;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition with c_in", test_num);
            a = 4'h3;
            b = 4'h4;
            c_in = 1'b1;
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition resulting in Max value (No carry out)", test_num);
            a = 4'hA;
            b = 4'h5;
            c_in = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple carry out (1 bit overflow)", test_num);
            a = 4'h8;
            b = 4'h8;
            c_in = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values with c_in", test_num);
            a = 4'hF;
            b = 4'hF;
            c_in = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary carry from LSB to MSB", test_num);
            a = 4'b0111;
            b = 4'b0000;
            c_in = 1'b1;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values with carry out", test_num);
            a = 4'hC;
            b = 4'h7;
            c_in = 1'b0;
            #1;

            check_outputs(1'b1, 4'h3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry in causing carry out", test_num);
            a = 4'hF;
            b = 4'h0;
            c_in = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            a = 4'b1010;
            b = 4'b0101;
            c_in = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1111);
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
        input expected_c_out;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: c_out=%b, sum=%h",
                         c_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%b, sum=%h",
                         expected_c_out, expected_sum);
                $display("  Got:      c_out=%b, sum=%h",
                         c_out, sum);
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
