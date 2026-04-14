`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [15:0] checksum;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .checksum(checksum),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            valid_in = 1'b0;
            checksum_in = 16'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Valid Input", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'h0A;
            valid_in = 1'b1;
            @(negedge clk);
            valid_in = 1'b0;


            #1;



            check_outputs(16'h0A0A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Inputs and Match Comparison", test_num);
            reset_dut();
            @(negedge clk);
            checksum_in = 16'h0403;
            valid_in = 1'b1;
            data_in = 8'h01; @(negedge clk);
            data_in = 8'h02; @(negedge clk);
            valid_in = 1'b0;

            #1;


            check_outputs(16'h0403, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 Consecutive Valid Inputs", test_num);
            reset_dut();
            @(negedge clk);
            valid_in = 1'b1;
            for (i = 1; i <= 10; i = i + 1) begin
                data_in = i[7:0];
                @(negedge clk);
            end
            valid_in = 1'b0;


            #1;



            check_outputs(16'hDC37, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Gating (valid_in)", test_num);
            reset_dut();
            @(negedge clk);
            valid_in = 1'b1;
            data_in = 8'h05; @(negedge clk);
            valid_in = 1'b0;
            data_in = 8'hFF; @(negedge clk);
            data_in = 8'hAA; @(negedge clk);
            valid_in = 1'b1;
            data_in = 8'h01; @(negedge clk);
            valid_in = 1'b0;
            #1;

            check_outputs(16'h0B06, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Handling", test_num);
            reset_dut();
            @(negedge clk);
            valid_in = 1'b1;
            data_in = 8'hFF; @(negedge clk);
            data_in = 8'h01; @(negedge clk);
            valid_in = 1'b0;

            #1;


            check_outputs(16'hFF00, 1'b0);
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
        input [15:0] expected_checksum;
        input expected_valid_out;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, valid_out=%b",
                         checksum, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, valid_out=%b",
                         expected_checksum, expected_valid_out);
                $display("  Got:      checksum=%h, valid_out=%b",
                         checksum, valid_out);
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
        $dumpvars(0,checksum_in, clk, data_in, rst, valid_in, checksum, valid_out);
    end

endmodule
