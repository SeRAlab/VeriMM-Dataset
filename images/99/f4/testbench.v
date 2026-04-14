`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
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
            valid_in = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Byte (0x11)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            data_in = 8'h11;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 0;
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h1212, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Two Bytes (0x11, 0x22)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            data_in = 8'h11;
            valid_in = 1;
            @(posedge clk);
            #1;
            data_in = 8'h22;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 0;
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h4634, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Modulo Boundary (0xFA)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            data_in = 8'hFA;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 0;
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h0000, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflowing Modulo (0xFF, 0xFF)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            data_in = 8'hFF;
            valid_in = 1;
            @(posedge clk);
            #1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 0;
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h0E09, 1);
        end
        endtask

    task testcase005;

        reg [7:0] data [0:8];
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multi-byte string (Wikipedia)", test_num);
            data[0] = 8'h57; data[1] = 8'h69; data[2] = 8'h6B; data[3] = 8'h69;
            data[4] = 8'h70; data[5] = 8'h65; data[6] = 8'h64; data[7] = 8'h69;
            data[8] = 8'h61;
            reset_dut();
            @(posedge clk);
            #1;
            valid_in = 1;
            for (i = 0; i < 9; i = i + 1) begin
                data_in = data[i];
                @(posedge clk);
                #1;
            end
            valid_in = 0;
            data_in = 0;
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h40A7, 1);
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
        $dumpvars(0,clk, data_in, rst, valid_in, checksum, valid_out);
    end

endmodule
