`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg io_pins_rxd_i_ival;
    reg io_pins_txd_i_ival;
    reg io_uart_txd;
    reg reset;
    wire io_pins_rxd_o_ds;
    wire io_pins_rxd_o_ie;
    wire io_pins_rxd_o_oe;
    wire io_pins_rxd_o_oval;
    wire io_pins_rxd_o_pue;
    wire io_pins_txd_o_ds;
    wire io_pins_txd_o_ie;
    wire io_pins_txd_o_oe;
    wire io_pins_txd_o_oval;
    wire io_pins_txd_o_pue;
    wire io_uart_rxd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_pins_rxd_i_ival(io_pins_rxd_i_ival),
        .io_pins_txd_i_ival(io_pins_txd_i_ival),
        .io_uart_txd(io_uart_txd),
        .reset(reset),
        .io_pins_rxd_o_ds(io_pins_rxd_o_ds),
        .io_pins_rxd_o_ie(io_pins_rxd_o_ie),
        .io_pins_rxd_o_oe(io_pins_rxd_o_oe),
        .io_pins_rxd_o_oval(io_pins_rxd_o_oval),
        .io_pins_rxd_o_pue(io_pins_rxd_o_pue),
        .io_pins_txd_o_ds(io_pins_txd_o_ds),
        .io_pins_txd_o_ie(io_pins_txd_o_ie),
        .io_pins_txd_o_oe(io_pins_txd_o_oe),
        .io_pins_txd_o_oval(io_pins_txd_o_oval),
        .io_pins_txd_o_pue(io_pins_txd_o_pue),
        .io_uart_rxd(io_uart_rxd)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and Idle State (TX=0, RX_VAL=0)", test_num);
            reset = 1;
            clock = 0;
            io_uart_txd = 0;
            io_pins_rxd_i_ival = 0;
            io_pins_txd_i_ival = 0;
            #20;
            reset = 0;
            #20;




            #1;





            check_outputs(0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: UART TX to GPIO TX OVAL (TX=1, RX_VAL=0)", test_num);
            reset = 1;
            #20;
            reset = 0;
            io_uart_txd = 1;
            io_pins_rxd_i_ival = 0;
            #20;




            #1;





            check_outputs(0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: GPIO RX IVAL to UART RXD (TX=0, RX_VAL=1)", test_num);
            reset = 1;
            #20;
            reset = 0;
            io_uart_txd = 0;
            io_pins_rxd_i_ival = 1;
            #20;




            #1;





            check_outputs(0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous TX and RX Path (TX=1, RX_VAL=1)", test_num);
            reset = 1;
            #20;
            reset = 0;
            io_uart_txd = 1;
            io_pins_rxd_i_ival = 1;
            #20;




            #1;





            check_outputs(0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggling UART TX (TX=0->1->0, RX_VAL=0)", test_num);
            reset = 1;
            #20;
            reset = 0;
            io_pins_rxd_i_ival = 0;

            io_uart_txd = 0; #10;
            io_uart_txd = 1; #10;
            io_uart_txd = 0; #10;


            #1;



            check_outputs(0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0);
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
        input expected_io_pins_rxd_o_ds;
        input expected_io_pins_rxd_o_ie;
        input expected_io_pins_rxd_o_oe;
        input expected_io_pins_rxd_o_oval;
        input expected_io_pins_rxd_o_pue;
        input expected_io_pins_txd_o_ds;
        input expected_io_pins_txd_o_ie;
        input expected_io_pins_txd_o_oe;
        input expected_io_pins_txd_o_oval;
        input expected_io_pins_txd_o_pue;
        input expected_io_uart_rxd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_pins_rxd_o_ds === (expected_io_pins_rxd_o_ds ^ io_pins_rxd_o_ds ^ expected_io_pins_rxd_o_ds) &&
                expected_io_pins_rxd_o_ie === (expected_io_pins_rxd_o_ie ^ io_pins_rxd_o_ie ^ expected_io_pins_rxd_o_ie) &&
                expected_io_pins_rxd_o_oe === (expected_io_pins_rxd_o_oe ^ io_pins_rxd_o_oe ^ expected_io_pins_rxd_o_oe) &&
                expected_io_pins_rxd_o_oval === (expected_io_pins_rxd_o_oval ^ io_pins_rxd_o_oval ^ expected_io_pins_rxd_o_oval) &&
                expected_io_pins_rxd_o_pue === (expected_io_pins_rxd_o_pue ^ io_pins_rxd_o_pue ^ expected_io_pins_rxd_o_pue) &&
                expected_io_pins_txd_o_ds === (expected_io_pins_txd_o_ds ^ io_pins_txd_o_ds ^ expected_io_pins_txd_o_ds) &&
                expected_io_pins_txd_o_ie === (expected_io_pins_txd_o_ie ^ io_pins_txd_o_ie ^ expected_io_pins_txd_o_ie) &&
                expected_io_pins_txd_o_oe === (expected_io_pins_txd_o_oe ^ io_pins_txd_o_oe ^ expected_io_pins_txd_o_oe) &&
                expected_io_pins_txd_o_oval === (expected_io_pins_txd_o_oval ^ io_pins_txd_o_oval ^ expected_io_pins_txd_o_oval) &&
                expected_io_pins_txd_o_pue === (expected_io_pins_txd_o_pue ^ io_pins_txd_o_pue ^ expected_io_pins_txd_o_pue) &&
                expected_io_uart_rxd === (expected_io_uart_rxd ^ io_uart_rxd ^ expected_io_uart_rxd)) begin
                $display("PASS");
                $display("  Outputs: io_pins_rxd_o_ds=%b, io_pins_rxd_o_ie=%b, io_pins_rxd_o_oe=%b, io_pins_rxd_o_oval=%b, io_pins_rxd_o_pue=%b, io_pins_txd_o_ds=%b, io_pins_txd_o_ie=%b, io_pins_txd_o_oe=%b, io_pins_txd_o_oval=%b, io_pins_txd_o_pue=%b, io_uart_rxd=%b",
                         io_pins_rxd_o_ds, io_pins_rxd_o_ie, io_pins_rxd_o_oe, io_pins_rxd_o_oval, io_pins_rxd_o_pue, io_pins_txd_o_ds, io_pins_txd_o_ie, io_pins_txd_o_oe, io_pins_txd_o_oval, io_pins_txd_o_pue, io_uart_rxd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_pins_rxd_o_ds=%b, io_pins_rxd_o_ie=%b, io_pins_rxd_o_oe=%b, io_pins_rxd_o_oval=%b, io_pins_rxd_o_pue=%b, io_pins_txd_o_ds=%b, io_pins_txd_o_ie=%b, io_pins_txd_o_oe=%b, io_pins_txd_o_oval=%b, io_pins_txd_o_pue=%b, io_uart_rxd=%b",
                         expected_io_pins_rxd_o_ds, expected_io_pins_rxd_o_ie, expected_io_pins_rxd_o_oe, expected_io_pins_rxd_o_oval, expected_io_pins_rxd_o_pue, expected_io_pins_txd_o_ds, expected_io_pins_txd_o_ie, expected_io_pins_txd_o_oe, expected_io_pins_txd_o_oval, expected_io_pins_txd_o_pue, expected_io_uart_rxd);
                $display("  Got:      io_pins_rxd_o_ds=%b, io_pins_rxd_o_ie=%b, io_pins_rxd_o_oe=%b, io_pins_rxd_o_oval=%b, io_pins_rxd_o_pue=%b, io_pins_txd_o_ds=%b, io_pins_txd_o_ie=%b, io_pins_txd_o_oe=%b, io_pins_txd_o_oval=%b, io_pins_txd_o_pue=%b, io_uart_rxd=%b",
                         io_pins_rxd_o_ds, io_pins_rxd_o_ie, io_pins_rxd_o_oe, io_pins_rxd_o_oval, io_pins_rxd_o_pue, io_pins_txd_o_ds, io_pins_txd_o_ie, io_pins_txd_o_oe, io_pins_txd_o_oval, io_pins_txd_o_pue, io_uart_rxd);
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

endmodule
