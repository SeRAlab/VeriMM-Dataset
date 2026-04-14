`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg out_ready;
    reg reset_n;
    wire [7:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset_n(reset_n),
        .out_data(out_data),
        .out_valid(out_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Power-on Reset Check", test_num);
            reset_n = 0;
            in_valid = 0;
            in_data = 8'h00;
            out_ready = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single Data Transfer (Handshake Success)", test_num);
            reset_n = 0; @(posedge clk); reset_n = 1;
            in_valid = 1;
            in_data = 8'hA5;
            out_ready = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Backpressure (Ready=0)", test_num);
            reset_n = 0; @(posedge clk); reset_n = 1;


            in_valid = 1; in_data = 8'h11; out_ready = 1;
            @(posedge clk);


            in_valid = 1; in_data = 8'h22; out_ready = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Sequential Pipeline Flow", test_num);
            reset_n = 0; @(posedge clk); reset_n = 1;
            in_valid = 1;
            out_ready = 1;

            in_data = 8'h01; @(posedge clk);
            in_data = 8'h02; @(posedge clk);
            in_data = 8'h03; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h03, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Input Invalid (Bubble Injection)", test_num);
            reset_n = 0; @(posedge clk); reset_n = 1;


            in_valid = 1; in_data = 8'hFF; out_ready = 1;
            @(posedge clk);


            in_valid = 0; out_ready = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 1'b0);
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
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
