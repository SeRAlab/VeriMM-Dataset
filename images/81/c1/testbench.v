`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Baud16Tick;
    reg RxD_ser;
    reg sys_clk;
    wire CTS;
    wire [7:0] TxD_par;
    wire TxD_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Baud16Tick(Baud16Tick),
        .RxD_ser(RxD_ser),
        .sys_clk(sys_clk),
        .CTS(CTS),
        .TxD_par(TxD_par),
        .TxD_ready(TxD_ready)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            RxD_ser = 1;
            Baud16Tick = 0;
            repeat (10) @(posedge sys_clk);
        end
        endtask
    task pulse_tick;

        begin
            @(posedge sys_clk);
            Baud16Tick = 1;
            @(posedge sys_clk);
            Baud16Tick = 0;

            repeat (3) @(posedge sys_clk);
        end
        endtask

    task send_uart_byte;

        input [7:0] data;
        integer i;
        begin

            RxD_ser = 0;
            repeat (16) pulse_tick();


            for (i = 0; i < 8; i = i + 1) begin
                RxD_ser = data[i];
                repeat (16) pulse_tick();
            end


            RxD_ser = 1;
            repeat (16) pulse_tick();
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Sending 0x41 ('A')", test_num);
            reset_dut();
            send_uart_byte(8'h41);



            #1;




            check_outputs(CTS, 8'h41, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sending 0x55", test_num);
            reset_dut();
            send_uart_byte(8'h55);
            #1;

            check_outputs(CTS, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sending 0x00", test_num);
            reset_dut();
            send_uart_byte(8'h00);
            #1;

            check_outputs(CTS, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sending 0xFF", test_num);
            reset_dut();
            send_uart_byte(8'hFF);
            #1;

            check_outputs(CTS, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Sending 0x12", test_num);
            reset_dut();
            send_uart_byte(8'h12);
            #1;

            check_outputs(CTS, 8'h12, 1'b1);
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
        input expected_CTS;
        input [7:0] expected_TxD_par;
        input expected_TxD_ready;
        begin
            if (expected_CTS === (expected_CTS ^ CTS ^ expected_CTS) &&
                expected_TxD_par === (expected_TxD_par ^ TxD_par ^ expected_TxD_par) &&
                expected_TxD_ready === (expected_TxD_ready ^ TxD_ready ^ expected_TxD_ready)) begin
                $display("PASS");
                $display("  Outputs: CTS=%b, TxD_par=%h, TxD_ready=%b",
                         CTS, TxD_par, TxD_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CTS=%b, TxD_par=%h, TxD_ready=%b",
                         expected_CTS, expected_TxD_par, expected_TxD_ready);
                $display("  Got:      CTS=%b, TxD_par=%h, TxD_ready=%b",
                         CTS, TxD_par, TxD_ready);
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
        $dumpvars(0,Baud16Tick, RxD_ser, sys_clk, CTS, TxD_par, TxD_ready);
    end

endmodule
