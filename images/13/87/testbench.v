`timescale 1ns/1ps

module CRC_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg rst;
    wire [3:0] crc_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CRC_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rst(rst),
        .crc_out(crc_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 4'h0;
            @(posedge clk);
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input data_in = 4'b0000", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b0000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input data_in = 4'b1000", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b1000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input data_in = 4'b0001", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b0001;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input data_in = 4'b1011", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b1011;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input data_in = 4'b1111", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b1111;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input data_in = 4'b0101", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b0101;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input data_in = 4'b1010", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'b1010;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CRC_4bit Testbench");
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
        input [3:0] expected_crc_out;
        input expected_ready;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, ready=%b",
                         crc_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, ready=%b",
                         expected_crc_out, expected_ready);
                $display("  Got:      crc_out=%h, ready=%b",
                         crc_out, ready);
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
        $dumpvars(0,clk, data_in, enable, rst, crc_out, ready);
    end

endmodule
