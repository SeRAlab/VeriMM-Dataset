`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [31:0] checksum_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .checksum_out(checksum_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] b;
        begin
            data_in = b;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            send_byte(8'h00);
            $display("Test Case 001: Single byte 0x00");
            #1;

            check_outputs(32'h00010001, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            send_byte(8'h41);
            $display("Test Case 002: Single character 'A'");
            #1;

            check_outputs(32'h00420042, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            send_byte("W"); send_byte("i"); send_byte("k"); send_byte("i");
            send_byte("p"); send_byte("e"); send_byte("d"); send_byte("i");
            send_byte("a");
            $display("Test Case 003: String 'Wikipedia'");
            #1;

            check_outputs(32'h11E60398, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            send_byte("1"); send_byte("2"); send_byte("3");
            send_byte("4"); send_byte("5"); send_byte("6");
            send_byte("7"); send_byte("8"); send_byte("9");
            $display("Test Case 004: String '123456789'");
            #1;

            check_outputs(32'h091E01CA, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            for(i=0; i<20; i=i+1) begin
                send_byte(8'hFF);
            end
            $display("Test Case 005: 20 bytes of 0xFF (Accumulator Growth)");

            #1;


            check_outputs(32'hC74213ED, 1'b0);
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
        input [31:0] expected_checksum_out;
        input expected_error;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, error=%b",
                         checksum_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, error=%b",
                         expected_checksum_out, expected_error);
                $display("  Got:      checksum_out=%h, error=%b",
                         checksum_out, error);
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
        $dumpvars(0,clk, data_in, rst, checksum_out, error);
    end

endmodule
