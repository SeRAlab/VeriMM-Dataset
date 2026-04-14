`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] rx_a;
    reg [3:0] rx_b;
    reg rx_c;
    wire tx_c;
    wire [3:0] tx_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_a(rx_a),
        .rx_b(rx_b),
        .rx_c(rx_c),
        .tx_c(tx_c),
        .tx_s(tx_s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0 + 0", test_num);
            rx_a = 4'd0;
            rx_b = 4'd0;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 4 + 3 + 0", test_num);
            rx_a = 4'd4;
            rx_b = 4'd3;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5 + 4 + 0", test_num);
            rx_a = 4'd5;
            rx_b = 4'd4;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5 + 5 + 0", test_num);
            rx_a = 4'd5;
            rx_b = 4'd5;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 9 + 9 + 0", test_num);
            rx_a = 4'd9;
            rx_b = 4'd9;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0 + 1", test_num);
            rx_a = 4'd0;
            rx_b = 4'd0;
            rx_c = 1'b1;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 4 + 5 + 1", test_num);
            rx_a = 4'd4;
            rx_b = 4'd5;
            rx_c = 1'b1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 9 + 9 + 1", test_num);
            rx_a = 4'd9;
            rx_b = 4'd9;
            rx_c = 1'b1;
            #1;

            check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8 + 7 + 0", test_num);
            rx_a = 4'd8;
            rx_b = 4'd7;
            rx_c = 1'b0;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1 + 1 + 1", test_num);
            rx_a = 4'd1;
            rx_b = 4'd1;
            rx_c = 1'b1;
            #1;

            check_outputs(1'b0, 4'd3);
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
        input expected_tx_c;
        input [3:0] expected_tx_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_c === (expected_tx_c ^ tx_c ^ expected_tx_c) &&
                expected_tx_s === (expected_tx_s ^ tx_s ^ expected_tx_s)) begin
                $display("PASS");
                $display("  Outputs: tx_c=%b, tx_s=%h",
                         tx_c, tx_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_c=%b, tx_s=%h",
                         expected_tx_c, expected_tx_s);
                $display("  Got:      tx_c=%b, tx_s=%h",
                         tx_c, tx_s);
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
