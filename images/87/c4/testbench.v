`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd1;
    reg [3:0] bcd2;
    reg [3:0] bcd3;
    reg [3:0] bcd4;
    wire [7:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4),
        .bin(bin)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid BCD inputs (bcd1=5, bcd2=3, others=0)", test_num);
            bcd1 = 4'd5;
            bcd2 = 4'd3;
            bcd3 = 4'd0;
            bcd4 = 4'd0;
            #1;

            check_outputs(8'h35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary valid BCD inputs (all 9s)", test_num);
            bcd1 = 4'd9;
            bcd2 = 4'd9;
            bcd3 = 4'd9;
            bcd4 = 4'd9;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid bcd1 (>9)", test_num);
            bcd1 = 4'hA;
            bcd2 = 4'd1;
            bcd3 = 4'd1;
            bcd4 = 4'd1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid bcd2 (>9)", test_num);
            bcd1 = 4'd2;
            bcd2 = 4'hB;
            bcd3 = 4'd2;
            bcd4 = 4'd2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid bcd3 (>9)", test_num);
            bcd1 = 4'd3;
            bcd2 = 4'd3;
            bcd3 = 4'hC;
            bcd4 = 4'd3;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid bcd4 (>9)", test_num);
            bcd1 = 4'd4;
            bcd2 = 4'd4;
            bcd3 = 4'd4;
            bcd4 = 4'hF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zero inputs", test_num);
            bcd1 = 4'd0;
            bcd2 = 4'd0;
            bcd3 = 4'd0;
            bcd4 = 4'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid BCD, bcd3/bcd4 not 0", test_num);
            bcd1 = 4'd7;
            bcd2 = 4'd8;
            bcd3 = 4'd1;
            bcd4 = 4'd2;
            #1;

            check_outputs(8'h87);
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
        input [7:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
