`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(data),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx = 1;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_frame;

        input [7:0] byte_in;
        input parity_bit;
        integer i;
        begin

            @(negedge clk);
            rx = 0;

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                rx = byte_in[i];
            end

            @(negedge clk);
            rx = parity_bit;


            @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid 0x55, Even Parity 0", test_num);
            reset_dut();
            send_frame(8'h55, 1'b0);
            #1;

            check_outputs(8'h55, 1'b1);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid 0x01, Even Parity 1", test_num);
            reset_dut();
            send_frame(8'h01, 1'b1);
            #1;

            check_outputs(8'h01, 1'b1);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid 0xFF, Even Parity 0", test_num);
            reset_dut();
            send_frame(8'hFF, 1'b0);
            #1;

            check_outputs(8'hFF, 1'b1);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid 0x00, Even Parity 0", test_num);
            reset_dut();
            send_frame(8'h00, 1'b0);
            #1;

            check_outputs(8'h00, 1'b1);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Parity (0x55, Expected 0, Sent 1)", test_num);
            reset_dut();
            send_frame(8'h55, 1'b1);

            #1;


            check_outputs(data, 1'b0);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid Parity (0x01, Expected 1, Sent 0)", test_num);
            reset_dut();
            send_frame(8'h01, 1'b0);
            #1;

            check_outputs(data, 1'b0);
            @(negedge clk) rx = 1;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive valid frames (0xAA then 0x33)", test_num);
            reset_dut();
            send_frame(8'hAA, 1'b0);
            #1;

            check_outputs(8'hAA, 1'b1);
            @(negedge clk) rx = 1;
            repeat(2) @(posedge clk);
            send_frame(8'h33, 1'b0);
            #1;

            check_outputs(8'h33, 1'b1);
            @(negedge clk) rx = 1;
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
        input [7:0] expected_data;
        input expected_valid;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data=%h, valid=%b",
                         data, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, valid=%b",
                         expected_data, expected_valid);
                $display("  Got:      data=%h, valid=%b",
                         data, valid);
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
        $dumpvars(0,clk, reset, rx, data, valid);
    end

endmodule
