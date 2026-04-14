`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] rx_a;
    reg [31:0] rx_b;
    reg [31:0] rx_c;
    wire tx_carry;
    wire [31:0] tx_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_a(rx_a),
        .rx_b(rx_b),
        .rx_c(rx_c),
        .tx_carry(tx_carry),
        .tx_sum(tx_sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            rx_a = 32'h00000000;
            rx_b = 32'h00000000;
            rx_c = 32'h00000000;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition without overflow", test_num);
            rx_a = 32'd1000;
            rx_b = 32'd2000;
            rx_c = 32'd3000;
            #1;

            check_outputs(1'b0, 32'd6000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum exactly at maximum representable (0xFFFFFFFF)", test_num);
            rx_a = 32'hFFFFFFFD;
            rx_b = 32'h00000001;
            rx_c = 32'h00000001;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum exactly at 2^32 (Minimal overflow)", test_num);
            rx_a = 32'hFFFFFFFE;
            rx_b = 32'h00000001;
            rx_c = 32'h00000001;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition of three maximum values", test_num);
            rx_a = 32'hFFFFFFFF;
            rx_b = 32'hFFFFFFFF;
            rx_c = 32'hFFFFFFFF;


            #1;



            check_outputs(1'b1, 32'hFFFFFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two-operand overflow with zero third operand", test_num);
            rx_a = 32'h80000000;
            rx_b = 32'h80000000;
            rx_c = 32'h00000000;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed large values with overflow", test_num);
            rx_a = 32'h12345678;
            rx_b = 32'h87654321;
            rx_c = 32'hFFFFFFFF;

            #1;


            check_outputs(1'b1, 32'h99999998);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High carry check (Sum > 2*2^32)", test_num);
            rx_a = 32'hFFFFFFFF;
            rx_b = 32'hFFFFFFFF;
            rx_c = 32'h00000002;


            #1;



            check_outputs(1'b1, 32'h00000001);
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
        input expected_tx_carry;
        input [31:0] expected_tx_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_carry === (expected_tx_carry ^ tx_carry ^ expected_tx_carry) &&
                expected_tx_sum === (expected_tx_sum ^ tx_sum ^ expected_tx_sum)) begin
                $display("PASS");
                $display("  Outputs: tx_carry=%b, tx_sum=%h",
                         tx_carry, tx_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_carry=%b, tx_sum=%h",
                         expected_tx_carry, expected_tx_sum);
                $display("  Got:      tx_carry=%b, tx_sum=%h",
                         tx_carry, tx_sum);
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
