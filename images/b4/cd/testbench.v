`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire out_parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .out_parity(out_parity)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 8'b00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            a = 8'b11111111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single Bit Set", test_num);
            a = 8'b00000001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Two Bits Set", test_num);
            a = 8'b00000011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits (10101010)", test_num);
            a = 8'b10101010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Seven Bits Set", test_num);
            a = 8'b01111111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Random Pattern (3 ones)", test_num);
            a = 8'b11000100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Random Pattern (6 ones)", test_num);
            a = 8'b10111101;
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
        input expected_out_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_parity === (expected_out_parity ^ out_parity ^ expected_out_parity)) begin
                $display("PASS");
                $display("  Outputs: out_parity=%b",
                         out_parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_parity=%b",
                         expected_out_parity);
                $display("  Got:      out_parity=%b",
                         out_parity);
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
