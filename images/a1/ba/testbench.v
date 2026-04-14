`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire out_greater_than_or_equal_to_8;
    wire [7:0] out_not;
    wire [3:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out_greater_than_or_equal_to_8(out_greater_than_or_equal_to_8),
        .out_not(out_not),
        .out_sum(out_sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0;
            b = 4'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'd2;
            b = 4'd3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hDC, 4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'd4;
            b = 4'd4;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'hBB, 4'd8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'd7;
            b = 4'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'h8A, 4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'hF;
            b = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 8'h00, 4'hE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'd8;
            b = 4'd8;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h77, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            a = 4'd0;
            b = 4'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'hFF, 4'd0);
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
        input expected_out_greater_than_or_equal_to_8;
        input [7:0] expected_out_not;
        input [3:0] expected_out_sum;
        begin
            if (expected_out_greater_than_or_equal_to_8 === (expected_out_greater_than_or_equal_to_8 ^ out_greater_than_or_equal_to_8 ^ expected_out_greater_than_or_equal_to_8) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_greater_than_or_equal_to_8=%b, out_not=%h, out_sum=%h",
                         out_greater_than_or_equal_to_8, out_not, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_greater_than_or_equal_to_8=%b, out_not=%h, out_sum=%h",
                         expected_out_greater_than_or_equal_to_8, expected_out_not, expected_out_sum);
                $display("  Got:      out_greater_than_or_equal_to_8=%b, out_not=%h, out_sum=%h",
                         out_greater_than_or_equal_to_8, out_not, out_sum);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, out_greater_than_or_equal_to_8, out_not, out_sum);
    end

endmodule
