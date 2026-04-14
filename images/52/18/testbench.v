`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btnc;
    reg btnd;
    reg btnl;
    reg btnr;
    reg btnu;
    reg clk_125mhz;
    reg rst_125mhz;
    reg [7:0] sw;
    reg uart_rts;
    reg uart_txd;
    wire [7:0] led;
    wire ledc;
    wire ledd;
    wire ledl;
    wire ledr;
    wire ledu;
    wire uart_cts;
    wire uart_rxd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btnc(btnc),
        .btnd(btnd),
        .btnl(btnl),
        .btnr(btnr),
        .btnu(btnu),
        .clk_125mhz(clk_125mhz),
        .rst_125mhz(rst_125mhz),
        .sw(sw),
        .uart_rts(uart_rts),
        .uart_txd(uart_txd),
        .led(led),
        .ledc(ledc),
        .ledd(ledd),
        .ledl(ledl),
        .ledr(ledr),
        .ledu(ledu),
        .uart_cts(uart_cts),
        .uart_rxd(uart_rxd)
    );

    // Clock generation (10ns period)
    initial begin
        clk_125mhz = 0;
        forever #5 clk_125mhz = ~clk_125mhz;
    end

        task reset_dut;

        begin
            rst_125mhz = 1;
            btnu = 0;
            btnl = 0;
            btnd = 0;
            btnr = 0;
            btnc = 0;
            sw = 8'h00;
            uart_txd = 1;
            uart_rts = 0;
            repeat (5) @(posedge clk_125mhz);
            #1;
            rst_125mhz = 0;
            repeat (2) @(posedge clk_125mhz);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Button Up and Down Mapping", test_num);
            reset_dut();
            btnu = 1;
            btnd = 1;
            repeat (2) @(posedge clk_125mhz);
            #1;

            #1;


            check_outputs(8'h00, 0, 1, 0, 0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Button Left, Right, and Center Mapping", test_num);
            reset_dut();
            btnl = 1;
            btnr = 1;
            btnc = 1;
            repeat (2) @(posedge clk_125mhz);
            #1;

            #1;


            check_outputs(8'h00, 1, 0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Switch to LED Pattern Verification", test_num);
            reset_dut();
            sw = 8'hAA;
            repeat (2) @(posedge clk_125mhz);
            #1;
            #1;

            check_outputs(8'hAA, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: UART Interface Logic", test_num);
            reset_dut();
            uart_txd = 0;
            uart_rts = 1;
            repeat (2) @(posedge clk_125mhz);
            #1;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Combined Inputs Stress Test", test_num);
            reset_dut();
            btnu = 1;
            btnd = 0;
            btnl = 1;
            btnr = 0;
            btnc = 1;
            sw = 8'hFF;
            uart_txd = 0;
            uart_rts = 0;
            repeat (2) @(posedge clk_125mhz);
            #1;

            #1;


            check_outputs(8'hFF, 1, 0, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Toggle/Pulse check", test_num);
            reset_dut();

            btnu = 1;
            sw = 8'h55;
            repeat (1) @(posedge clk_125mhz);
            btnu = 0;
            repeat (1) @(posedge clk_125mhz);
            #1;



            #1;




            check_outputs(8'h55, 0, 0, 0, 0, 0, 0, 1);
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
        input [7:0] expected_led;
        input expected_ledc;
        input expected_ledd;
        input expected_ledl;
        input expected_ledr;
        input expected_ledu;
        input expected_uart_cts;
        input expected_uart_rxd;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_ledc === (expected_ledc ^ ledc ^ expected_ledc) &&
                expected_ledd === (expected_ledd ^ ledd ^ expected_ledd) &&
                expected_ledl === (expected_ledl ^ ledl ^ expected_ledl) &&
                expected_ledr === (expected_ledr ^ ledr ^ expected_ledr) &&
                expected_ledu === (expected_ledu ^ ledu ^ expected_ledu) &&
                expected_uart_cts === (expected_uart_cts ^ uart_cts ^ expected_uart_cts) &&
                expected_uart_rxd === (expected_uart_rxd ^ uart_rxd ^ expected_uart_rxd)) begin
                $display("PASS");
                $display("  Outputs: led=%h, ledc=%b, ledd=%b, ledl=%b, ledr=%b, ledu=%b, uart_cts=%b, uart_rxd=%b",
                         led, ledc, ledd, ledl, ledr, ledu, uart_cts, uart_rxd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h, ledc=%b, ledd=%b, ledl=%b, ledr=%b, ledu=%b, uart_cts=%b, uart_rxd=%b",
                         expected_led, expected_ledc, expected_ledd, expected_ledl, expected_ledr, expected_ledu, expected_uart_cts, expected_uart_rxd);
                $display("  Got:      led=%h, ledc=%b, ledd=%b, ledl=%b, ledr=%b, ledu=%b, uart_cts=%b, uart_rxd=%b",
                         led, ledc, ledd, ledl, ledr, ledu, uart_cts, uart_rxd);
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
        $dumpvars(0,btnc, btnd, btnl, btnr, btnu, clk_125mhz, rst_125mhz, sw, uart_rts, uart_txd, led, ledc, ledd, ledl, ledr, ledu, uart_cts, uart_rxd);
    end

endmodule
