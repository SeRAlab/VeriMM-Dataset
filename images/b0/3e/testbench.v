`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] in;
    wire [7:0] out_avg;
    wire [7:0] out_max;
    wire [7:0] out_min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_avg(out_avg),
        .out_max(out_max),
        .out_min(out_min)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        in = 100'b0;
        #10;
        #1;

        check_outputs(8'd0, 8'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        in = {100{1'b1}};
        #10;
        #1;

        check_outputs(8'd1, 8'd1, 8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (LSB)", test_num);
        in = 100'h1;
        #10;
        #1;

        check_outputs(8'd0, 8'd1, 8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (MSB)", test_num);
        in = (100'b1 << 99);
        #10;
        #1;

        check_outputs(8'd0, 8'd1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 50%% Bits Set (Alternating)", test_num);
        in = {50{2'b10}};
        #10;
        #1;

        check_outputs(8'd0, 8'd1, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 99%% Bits Set", test_num);
        in = ~100'h1;
        #10;
        #1;

        check_outputs(8'd0, 8'd1, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Half Block Set", test_num);
        in = {{50{1'b1}}, {50{1'b0}}};
        #10;
        #1;

        check_outputs(8'd0, 8'd1, 8'd0);
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
        input [7:0] expected_out_avg;
        input [7:0] expected_out_max;
        input [7:0] expected_out_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_avg === (expected_out_avg ^ out_avg ^ expected_out_avg) &&
                expected_out_max === (expected_out_max ^ out_max ^ expected_out_max) &&
                expected_out_min === (expected_out_min ^ out_min ^ expected_out_min)) begin
                $display("PASS");
                $display("  Outputs: out_avg=%h, out_max=%h, out_min=%h",
                         out_avg, out_max, out_min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_avg=%h, out_max=%h, out_min=%h",
                         expected_out_avg, expected_out_max, expected_out_min);
                $display("  Got:      out_avg=%h, out_max=%h, out_min=%h",
                         out_avg, out_max, out_min);
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
