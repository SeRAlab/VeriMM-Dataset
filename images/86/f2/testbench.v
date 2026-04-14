`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx_enabled;
    reg rxd;
    wire rx_avail;
    wire [7:0] rx_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rx_enabled(rx_enabled),
        .rxd(rxd),
        .rx_avail(rx_avail),
        .rx_data(rx_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rxd = 1;
            rx_enabled = 0;
            #(20);
            rst = 0;
            #(20);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0xA5", test_num);
            reset_dut();
            rx_enabled = 1;
            #(BIT_TIME);
            send_byte(8'hA5);

            #(BIT_TIME);
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0x5A", test_num);
            reset_dut();
            rx_enabled = 1;
            #(BIT_TIME);
            send_byte(8'h5A);
            #(BIT_TIME);
            #1;

            check_outputs(1'b1, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reception while disabled (rx_enabled=0)", test_num);
            reset_dut();
            rx_enabled = 0;
            #(BIT_TIME);
            send_byte(8'hFF);
            #(BIT_TIME);

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0x00", test_num);
            reset_dut();
            rx_enabled = 1;
            #(BIT_TIME);
            send_byte(8'h00);
            #(BIT_TIME);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0xFF", test_num);
            reset_dut();
            rx_enabled = 1;
            #(BIT_TIME);
            send_byte(8'hFF);
            #(BIT_TIME);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0x12 after reset", test_num);
            reset_dut();
            rx_enabled = 1;
            send_byte(8'h12);
            #(BIT_TIME);
            #1;

            check_outputs(1'b1, 8'h12);
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
        input expected_rx_avail;
        input [7:0] expected_rx_data;
        begin
            if (expected_rx_avail === (expected_rx_avail ^ rx_avail ^ expected_rx_avail) &&
                expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data)) begin
                $display("PASS");
                $display("  Outputs: rx_avail=%b, rx_data=%h",
                         rx_avail, rx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_avail=%b, rx_data=%h",
                         expected_rx_avail, expected_rx_data);
                $display("  Got:      rx_avail=%b, rx_data=%h",
                         rx_avail, rx_data);
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
        $dumpvars(0,clk, rst, rx_enabled, rxd, rx_avail, rx_data);
    end

endmodule
