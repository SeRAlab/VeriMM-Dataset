`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    reg reset;
    wire overflow;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset functionality check", test_num);

        reset = 1;
        in1 = 8'hFF;
        in2 = 8'hFF;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition without overflow (10 + 20)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd10;
        in2 = 8'd20;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary condition - maximum sum without overflow (255 + 0)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd255;
        in2 = 8'd0;
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum overflow condition (255 + 1)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd255;
        in2 = 8'd1;
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum overflow condition (255 + 255)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd255;
        in2 = 8'd255;
        #1;

        check_outputs(1'b1, 8'd254);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range overflow (128 + 128)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd128;
        in2 = 8'd128;
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero inputs addition", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd0;
        in2 = 8'd0;
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random values addition (100 + 50)", test_num);
        reset = 1; #5; reset = 0;
        in1 = 8'd100;
        in2 = 8'd50;
        #1;

        check_outputs(1'b0, 8'd150);
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
        input expected_overflow;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
