`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg _scs;
    reg clk;
    reg [7:0] in;
    reg sck;
    reg sdi;
    wire cmd;
    wire [7:0] out;
    wire rx;
    wire sdo;
    wire vld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._scs(_scs),
        .clk(clk),
        .in(in),
        .sck(sck),
        .sdi(sdi),
        .cmd(cmd),
        .out(out),
        .rx(rx),
        .sdo(sdo),
        .vld(vld)
    );

    // Clock generation (10ns period)
    initial begin
        _scs = 0;
        forever #5 _scs = ~_scs;
    end

        task reset_dut;

        begin
            _scs = 1;
            sck = 0;
            sdi = 0;
            in = 8'h00;
            #40;
        end
        endtask
    task spi_transfer;

        input [7:0] data_to_send;
        integer i;
        begin
            _scs = 0;
            #20;
            for (i = 7; i >= 0; i = i - 1) begin
                sdi = data_to_send[i];
                #20;
                sck = 1;
                #20;
                sck = 0;
            end
            #20;
            _scs = 1;
            #20;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: Data 0xAA...");
            reset_dut();
            in = 8'h55;
            spi_transfer(8'hAA);


            #1;



            check_outputs(0, 8'hAA, 0, 1'b0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: Data 0x3C...");
            reset_dut();
            in = 8'hFF;
            spi_transfer(8'h3C);
            #1;

            check_outputs(0, 8'h3C, 0, 1'b1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: Data 0x00...");
            reset_dut();
            in = 8'h00;
            spi_transfer(8'h00);
            #1;

            check_outputs(0, 8'h00, 0, 1'b0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: Data 0xFF...");
            reset_dut();
            in = 8'hAA;
            spi_transfer(8'hFF);
            #1;

            check_outputs(0, 8'hFF, 0, 1'b0, 1);
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
        input expected_cmd;
        input [7:0] expected_out;
        input expected_rx;
        input expected_sdo;
        input expected_vld;
        begin
            if (expected_cmd === (expected_cmd ^ cmd ^ expected_cmd) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_rx === (expected_rx ^ rx ^ expected_rx) &&
                expected_sdo === (expected_sdo ^ sdo ^ expected_sdo) &&
                expected_vld === (expected_vld ^ vld ^ expected_vld)) begin
                $display("PASS");
                $display("  Outputs: cmd=%b, out=%h, rx=%b, sdo=%b, vld=%b",
                         cmd, out, rx, sdo, vld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd=%b, out=%h, rx=%b, sdo=%b, vld=%b",
                         expected_cmd, expected_out, expected_rx, expected_sdo, expected_vld);
                $display("  Got:      cmd=%b, out=%h, rx=%b, sdo=%b, vld=%b",
                         cmd, out, rx, sdo, vld);
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
        $dumpvars(0,_scs, clk, in, sck, sdi, cmd, out, rx, sdo, vld);
    end

endmodule
