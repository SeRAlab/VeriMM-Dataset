`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire byte_received;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .byte_received(byte_received),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 1;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data_to_send;
        integer i;
        begin

            @(posedge clk);
            #1 serial_in = 0;


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1 serial_in = data_to_send[i];
            end


            @(posedge clk);
            #1 serial_in = 1;


            @(posedge clk);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0xA5", test_num);
            reset_dut();
            send_byte(8'hA5);
            #1 #1;
 check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0x5A", test_num);
            reset_dut();
            send_byte(8'h5A);
            #1 #1;
 check_outputs(1'b1, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0xFF", test_num);
            reset_dut();
            send_byte(8'hFF);
            #1 #1;
 check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0x00", test_num);
            reset_dut();
            send_byte(8'h00);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sending 0x3C", test_num);
            reset_dut();
            send_byte(8'h3C);
            #1 #1;
 check_outputs(1'b1, 8'h3C);
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
        input expected_byte_received;
        input [7:0] expected_data_out;
        begin
            if (expected_byte_received === (expected_byte_received ^ byte_received ^ expected_byte_received) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: byte_received=%b, data_out=%h",
                         byte_received, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: byte_received=%b, data_out=%h",
                         expected_byte_received, expected_data_out);
                $display("  Got:      byte_received=%b, data_out=%h",
                         byte_received, data_out);
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
        $dumpvars(0,clk, reset, serial_in, byte_received, data_out);
    end

endmodule
