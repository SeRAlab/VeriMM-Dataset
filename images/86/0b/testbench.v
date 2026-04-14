`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g1;
    reg g2a_n;
    reg g2b_n;
    reg [2:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g1(g1),
        .g2a_n(g2a_n),
        .g2b_n(g2b_n),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Disabled via G1 (G1=0)", test_num);
            g1 = 0; g2a_n = 0; g2b_n = 0; x = 3'b000;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Disabled via G2A_N (G2A_N=1)", test_num);
            g1 = 1; g2a_n = 1; g2b_n = 0; x = 3'b000;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Disabled via G2B_N (G2B_N=1)", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 1; x = 3'b000;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enabled, x=0", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd0;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enabled, x=1", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd1;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enabled, x=2", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd2;
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enabled, x=3", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd3;
            #1;

            check_outputs(8'b00001000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Enabled, x=4", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd4;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Enabled, x=5", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd5;
            #1;

            check_outputs(8'b00100000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Enabled, x=6", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd6;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Enabled, x=7", test_num);
            g1 = 1; g2a_n = 0; g2b_n = 0; x = 3'd7;
            #1;

            check_outputs(8'b10000000);
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
        testcase011();
        
        
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
