`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg busy;
    reg [4:0] channel;
    reg clk;
    reg [15:0] data_in;
    reg [15:0] dout;
    reg drdy;
    reg eoc;
    reg eos;
    reg jtaglocked;
    reg rd;
    reg rst;
    reg wr;
    wire [6:0] daddr;
    wire [15:0] data_out;
    wire den;
    wire [15:0] din;
    wire dwe;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .busy(busy),
        .channel(channel),
        .clk(clk),
        .data_in(data_in),
        .dout(dout),
        .drdy(drdy),
        .eoc(eoc),
        .eos(eos),
        .jtaglocked(jtaglocked),
        .rd(rd),
        .rst(rst),
        .wr(wr),
        .daddr(daddr),
        .data_out(data_out),
        .den(den),
        .din(din),
        .dwe(dwe),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rd = 0;
            wr = 0;
            addr = 0;
            data_in = 0;
            jtaglocked = 0;
            busy = 0;
            drdy = 0;
            eoc = 0;
            eos = 0;
            channel = 0;
            dout = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'h0, 16'h0, 1'b0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            addr = 7'h1A;
            data_in = 16'hDEAD;
            wr = 1;
            @(posedge clk);
            wr = 0;



            #1;
            #1;

            check_outputs(7'h1A, 16'h0, 1'b1, 16'hDEAD, 1'b1, 1'b0);


            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            addr = 7'h05;
            rd = 1;
            @(posedge clk);
            rd = 0;


            #1;

            if (den !== 1'b1 || dwe !== 1'b0 || daddr !== 7'h05) begin
                 $display("Read initiation failed");
            end


            @(posedge clk);
            dout = 16'hBEEF;
            drdy = 1;
            @(posedge clk);
            drdy = 0;
            #1;


            #1;



            check_outputs(7'h05, 16'hBEEF, 1'b0, 16'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            busy = 1;
            addr = 7'h20;
            wr = 1;
            @(posedge clk);
            wr = 0;


            #1;
            #1;

            check_outputs(7'h0, 16'h0, 1'b0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            jtaglocked = 1;
            addr = 7'h33;
            rd = 1;
            @(posedge clk);
            rd = 0;


            #1;
            #1;

            check_outputs(7'h0, 16'h0, 1'b0, 16'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            addr = 7'h40;
            rd = 1;
            @(posedge clk);
            rd = 0;


            repeat(3) @(posedge clk);


            if (valid !== 0) $display("Valid high too early");


            dout = 16'h55AA;
            drdy = 1;
            @(posedge clk);
            drdy = 0;
            #1;


            #1;



            check_outputs(7'h40, 16'h55AA, 1'b0, 16'h0, 1'b0, 1'b1);
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
        input [6:0] expected_daddr;
        input [15:0] expected_data_out;
        input expected_den;
        input [15:0] expected_din;
        input expected_dwe;
        input expected_valid;
        begin
            if (expected_daddr === (expected_daddr ^ daddr ^ expected_daddr) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_den === (expected_den ^ den ^ expected_den) &&
                expected_din === (expected_din ^ din ^ expected_din) &&
                expected_dwe === (expected_dwe ^ dwe ^ expected_dwe) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: daddr=%h, data_out=%h, den=%b, din=%h, dwe=%b, valid=%b",
                         daddr, data_out, den, din, dwe, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: daddr=%h, data_out=%h, den=%b, din=%h, dwe=%b, valid=%b",
                         expected_daddr, expected_data_out, expected_den, expected_din, expected_dwe, expected_valid);
                $display("  Got:      daddr=%h, data_out=%h, den=%b, din=%h, dwe=%b, valid=%b",
                         daddr, data_out, den, din, dwe, valid);
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
        $dumpvars(0,addr, busy, channel, clk, data_in, dout, drdy, eoc, eos, jtaglocked, rd, rst, wr, daddr, data_out, den, din, dwe, valid);
    end

endmodule
