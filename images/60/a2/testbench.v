`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock50;
    reg keyboard_clk;
    reg keyboard_data;
    reg read;
    reg reset;
    wire [7:0] scan_code;
    wire scan_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock50(clock50),
        .keyboard_clk(keyboard_clk),
        .keyboard_data(keyboard_data),
        .read(read),
        .reset(reset),
        .scan_code(scan_code),
        .scan_ready(scan_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clock50 = 0;
        forever #5 clock50 = ~clock50;
    end

        task reset_dut;

        begin
            reset = 1;
            keyboard_clk = 1;
            keyboard_data = 1;
            read = 0;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task send_bit;

        input val;
        begin
            keyboard_data = val;
            #500;
            keyboard_clk = 0;
            #1000;
            keyboard_clk = 1;
            #500;
        end
        endtask

    task send_ps2_byte;

        input [7:0] code;
        integer i;
        reg parity;
        begin
            parity = ~(^code);

            send_bit(0);
            for (i = 0; i < 8; i = i + 1) begin
                send_bit(code[i]);
            end
            send_bit(parity);
            send_bit(1);
            #2000;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Receive scan code 0x1C", test_num);
            reset_dut();
            send_ps2_byte(8'h1C);
            #100;
            #1;

            check_outputs(8'h1C, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Receive scan code 0x5A", test_num);
            reset_dut();
            send_ps2_byte(8'h5A);
            #100;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Verify read signal clears scan_ready", test_num);
            reset_dut();
            send_ps2_byte(8'h23);
            #100;
            read = 1;
            #20;
            read = 0;
            #100;

            #1;


            check_outputs(8'h23, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Receive consecutive codes (0xF0 then 0x1C)", test_num);
            reset_dut();


            send_ps2_byte(8'hF0);
            #100;
            read = 1; #20; read = 0; #100;


            send_ps2_byte(8'h1C);
            #100;
            #1;

            check_outputs(8'h1C, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Receive scan code 0x00", test_num);
            reset_dut();
            send_ps2_byte(8'h00);
            #100;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Receive scan code 0xFF", test_num);
            reset_dut();
            send_ps2_byte(8'hFF);
            #100;
            #1;

            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_scan_code;
        input expected_scan_ready;
        begin
            if (expected_scan_code === (expected_scan_code ^ scan_code ^ expected_scan_code) &&
                expected_scan_ready === (expected_scan_ready ^ scan_ready ^ expected_scan_ready)) begin
                $display("PASS");
                $display("  Outputs: scan_code=%h, scan_ready=%b",
                         scan_code, scan_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scan_code=%h, scan_ready=%b",
                         expected_scan_code, expected_scan_ready);
                $display("  Got:      scan_code=%h, scan_ready=%b",
                         scan_code, scan_ready);
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
        $dumpvars(0,clock50, keyboard_clk, keyboard_data, read, reset, scan_code, scan_ready);
    end

endmodule
