`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RX;
    reg clk;
    reg rst;
    wire busy;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RX(RX),
        .clk(clk),
        .rst(rst),
        .busy(busy),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            RX = 1;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] b;
        integer i;
        begin

            RX = 0;
            repeat (BIT_PERIOD) @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                RX = b[i];
                repeat (BIT_PERIOD) @(posedge clk);
            end


            RX = 1;
            repeat (BIT_PERIOD) @(posedge clk);


            repeat (5) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Receiving 0x55", test_num);
            send_byte(8'h55);
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Receiving 0xAA", test_num);
            send_byte(8'hAA);
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Receiving 0x00", test_num);
            send_byte(8'h00);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Receiving 0xFF", test_num);
            send_byte(8'hFF);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Receiving 0xA5", test_num);
            send_byte(8'hA5);
            #1;

            check_outputs(1'b0, 8'hA5);
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
        input expected_busy;
        input [7:0] expected_data;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data=%h",
                         busy, data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data=%h",
                         expected_busy, expected_data);
                $display("  Got:      busy=%b, data=%h",
                         busy, data);
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
        $dumpvars(0,RX, clk, rst, busy, data);
    end

endmodule
