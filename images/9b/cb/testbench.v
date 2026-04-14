`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Rx_done;
    reg clk;
    reg [7:0] data_Byte;
    reg rst_n;
    wire [15:0] tiwen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rx_done(Rx_done),
        .clk(clk),
        .data_Byte(data_Byte),
        .rst_n(rst_n),
        .tiwen(tiwen)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            Rx_done = 0;
            data_Byte = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] value;
        begin
            @(posedge clk);
            #1;
            data_Byte = value;
            Rx_done = 1;
            @(posedge clk);
            #1;
            Rx_done = 0;
            data_Byte = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Standard 10-byte sequence...", test_num);
            reset_dut();

            send_byte(8'h01);
            send_byte(8'h02);
            send_byte(8'h03);
            send_byte(8'h04);
            send_byte(8'h05);
            send_byte(8'h06);
            send_byte(8'h07);
            send_byte(8'h08);
            send_byte(8'h09);
            send_byte(8'h0A);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Sequence with unique values...", test_num);
            reset_dut();

            send_byte(8'hFF);
            send_byte(8'hEE);
            send_byte(8'hDD);
            send_byte(8'hCC);
            send_byte(8'hA5);
            send_byte(8'hBB);
            send_byte(8'hAA);
            send_byte(8'h99);
            send_byte(8'h88);
            send_byte(8'h77);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h00A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Reset mid-sequence test...", test_num);
            reset_dut();


            send_byte(8'h11);
            send_byte(8'h22);
            send_byte(8'h33);
            send_byte(8'h44);
            send_byte(8'h55);
            send_byte(8'h66);
            send_byte(8'h77);

            reset_dut();


            send_byte(8'hD1);
            send_byte(8'hD2);
            send_byte(8'hD3);
            send_byte(8'hD4);
            send_byte(8'hD5);
            send_byte(8'hD6);
            send_byte(8'hD7);
            send_byte(8'hD8);
            send_byte(8'hD9);
            send_byte(8'hDA);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h00D5);
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
        input [15:0] expected_tiwen;
        begin
            if (expected_tiwen === (expected_tiwen ^ tiwen ^ expected_tiwen)) begin
                $display("PASS");
                $display("  Outputs: tiwen=%h",
                         tiwen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tiwen=%h",
                         expected_tiwen);
                $display("  Got:      tiwen=%h",
                         tiwen);
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
        $dumpvars(0,Rx_done, clk, data_Byte, rst_n, tiwen);
    end

endmodule
