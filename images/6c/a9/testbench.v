`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] data_in;
    reg ren_w1;
    reg ren_w2;
    reg reset;
    reg wen;
    wire avail_w1;
    wire avail_w2;
    wire [1:0] count;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ren_w1(ren_w1),
        .ren_w2(ren_w2),
        .reset(reset),
        .wen(wen),
        .avail_w1(avail_w1),
        .avail_w2(avail_w2),
        .count(count),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State");
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0, 2'b00, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Write");
            reset_dut();
            wen = 1; data_in = 16'hAAAA;
            @(posedge clk);
            #1 wen = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 2'b01, 32'h0000AAAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Double Write (Full)");
            reset_dut();
            wen = 1; data_in = 16'hAAAA;
            @(posedge clk);
            #1 data_in = 16'hBBBB;
            @(posedge clk);
            #1 wen = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 2'b10, 32'hAAAABBBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write and Read One");
            reset_dut();
            wen = 1; data_in = 16'h1234;
            @(posedge clk);
            #1 wen = 0; ren_w1 = 1;
            @(posedge clk);
            #1 ren_w1 = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 2'b00, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full Buffer Single Read");
            reset_dut();
            wen = 1; data_in = 16'hAAAA; @(posedge clk);
            #1 data_in = 16'hBBBB; @(posedge clk);
            #1 wen = 0; ren_w1 = 1;
            @(posedge clk);
            #1 ren_w1 = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 2'b01, 32'h0000BBBB);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Multi-channel Read");
            reset_dut();
            wen = 1; data_in = 16'h1111; @(posedge clk);
            #1 data_in = 16'h2222; @(posedge clk);
            #1 wen = 0; ren_w1 = 1; ren_w2 = 1;
            @(posedge clk);
            #1 ren_w1 = 0; ren_w2 = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 2'b00, 32'h0);
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
        input expected_avail_w1;
        input expected_avail_w2;
        input [1:0] expected_count;
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avail_w1 === (expected_avail_w1 ^ avail_w1 ^ expected_avail_w1) &&
                expected_avail_w2 === (expected_avail_w2 ^ avail_w2 ^ expected_avail_w2) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: avail_w1=%b, avail_w2=%b, count=%h, data_out=%h",
                         avail_w1, avail_w2, count, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avail_w1=%b, avail_w2=%b, count=%h, data_out=%h",
                         expected_avail_w1, expected_avail_w2, expected_count, expected_data_out);
                $display("  Got:      avail_w1=%b, avail_w2=%b, count=%h, data_out=%h",
                         avail_w1, avail_w2, count, data_out);
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
