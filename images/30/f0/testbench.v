`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] bit_value_out;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .bit_value_out(bit_value_out),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 8'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic counting (5 repetitions)", test_num);
        reset_dut();
        data_in = 8'hAA;
        repeat(5) @(posedge clk);

        #1 #1;
 check_outputs(8'hAA, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Change of input value", test_num);
        reset_dut();
        data_in = 8'hAA;
        repeat(3) @(posedge clk);
        data_in = 8'hBB;
        repeat(2) @(posedge clk);

        #1 #1;
 check_outputs(8'hBB, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum count (15)", test_num);
        reset_dut();
        data_in = 8'hFF;
        repeat(15) @(posedge clk);
        #1 #1;
 check_outputs(8'hFF, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rapidly changing values", test_num);
        reset_dut();
        data_in = 8'h01; @(posedge clk);
        data_in = 8'h02; @(posedge clk);
        data_in = 8'h03; @(posedge clk);
        data_in = 8'h04; @(posedge clk);

        #1 #1;
 check_outputs(8'h04, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input sequence of zeros", test_num);
        reset_dut();
        data_in = 8'h00;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating values", test_num);
        reset_dut();
        data_in = 8'h55; repeat(2) @(posedge clk);
        data_in = 8'hAA; repeat(2) @(posedge clk);
        data_in = 8'h55; repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(8'h55, 4'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Encoder Testbench");
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
        input [7:0] expected_bit_value_out;
        input [3:0] expected_count_out;
        begin
            if (expected_bit_value_out === (expected_bit_value_out ^ bit_value_out ^ expected_bit_value_out) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: bit_value_out=%h, count_out=%h",
                         bit_value_out, count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_value_out=%h, count_out=%h",
                         expected_bit_value_out, expected_count_out);
                $display("  Got:      bit_value_out=%h, count_out=%h",
                         bit_value_out, count_out);
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
        $dumpvars(0,clk, data_in, rst, bit_value_out, count_out);
    end

endmodule
