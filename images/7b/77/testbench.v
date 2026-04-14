`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] num;
    reg rs232_rx;
    reg rst_n;
    reg sel_data;
    wire [7:0] rx_data;
    wire rx_en;
    wire tx_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .num(num),
        .rs232_rx(rs232_rx),
        .rst_n(rst_n),
        .sel_data(sel_data),
        .rx_data(rx_data),
        .rx_en(rx_en),
        .tx_en(tx_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            num = 0;
            rs232_rx = 1;
            sel_data = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task load_bit;

        input [3:0] bit_pos;
        input bit_val;
        begin
            @(posedge clk);
            num = bit_pos;
            rs232_rx = bit_val;
        end
        endtask

    task commit_data;

        begin
            @(posedge clk);
            num = 9;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0x55", test_num);
            reset_dut();


            load_bit(0, 1);
            load_bit(1, 0);
            load_bit(2, 1);
            load_bit(3, 0);
            load_bit(4, 1);
            load_bit(5, 0);
            load_bit(6, 1);
            load_bit(7, 0);

            commit_data();


            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0xAA", test_num);
            reset_dut();

            load_bit(0, 0);
            load_bit(1, 1);
            load_bit(2, 0);
            load_bit(3, 1);
            load_bit(4, 0);
            load_bit(5, 1);
            load_bit(6, 0);
            load_bit(7, 1);

            commit_data();

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0xFF", test_num);
            reset_dut();

            load_bit(0, 1);
            load_bit(1, 1);
            load_bit(2, 1);
            load_bit(3, 1);
            load_bit(4, 1);
            load_bit(5, 1);
            load_bit(6, 1);
            load_bit(7, 1);

            commit_data();

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Receiving 0x00", test_num);
            reset_dut();

            load_bit(0, 0);
            load_bit(1, 0);
            load_bit(2, 0);
            load_bit(3, 0);
            load_bit(4, 0);
            load_bit(5, 0);
            load_bit(6, 0);
            load_bit(7, 0);

            commit_data();

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Check", test_num);
            reset_dut();


            #2;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting bit position 3", test_num);
            reset_dut();

            load_bit(3, 0);
            load_bit(3, 1);


            load_bit(0, 0); load_bit(1, 0); load_bit(2, 0);
            load_bit(4, 0); load_bit(5, 0); load_bit(6, 0); load_bit(7, 0);

            commit_data();

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h08, 1'b1, 1'b1);
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
        input [7:0] expected_rx_data;
        input expected_rx_en;
        input expected_tx_en;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_en === (expected_rx_en ^ rx_en ^ expected_rx_en) &&
                expected_tx_en === (expected_tx_en ^ tx_en ^ expected_tx_en)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_en=%b, tx_en=%b",
                         rx_data, rx_en, tx_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_en=%b, tx_en=%b",
                         expected_rx_data, expected_rx_en, expected_tx_en);
                $display("  Got:      rx_data=%h, rx_en=%b, tx_en=%b",
                         rx_data, rx_en, tx_en);
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
        $dumpvars(0,clk, num, rs232_rx, rst_n, sel_data, rx_data, rx_en, tx_en);
    end

endmodule
