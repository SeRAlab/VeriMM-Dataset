`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RX;
    wire [7:0] data;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RX(RX),
        .data(data),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RX = 1;
            repeat (20) @(posedge CLK);
        end
        endtask
    task send_byte;

        input [7:0] byte_to_send;
        integer i;
        begin
            $display("  Sending Byte: 0x%h", byte_to_send);

            RX = 0;
            repeat (CLKS_PER_BIT) @(posedge CLK);

            for (i = 0; i < 8; i = i + 1) begin
                RX = byte_to_send[i];
                repeat (CLKS_PER_BIT) @(posedge CLK);
            end

            RX = 1;
            repeat (CLKS_PER_BIT) @(posedge CLK);

            repeat (2) @(posedge CLK);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Sending 0x55", test_num);
            reset_dut();
            send_byte(8'h55);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sending 0xAA", test_num);
            reset_dut();
            send_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Sending 0xA5", test_num);
            reset_dut();
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Sending 0x80", test_num);
            reset_dut();
            send_byte(8'h80);
            #1;

            check_outputs(8'h80, 1'b1);
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
        $dumpvars(0,CLK, RX, data, valid);
    end

endmodule
