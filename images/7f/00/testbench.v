`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [8:0] din;
    reg miso;
    reg write;
    wire cs;
    wire [7:0] dout;
    wire mosi;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .din(din),
        .miso(miso),
        .write(write),
        .cs(cs),
        .dout(dout),
        .mosi(mosi),
        .sck(sck)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        write = 0;
        din = 9'h0;
        miso = 0;


        repeat(5) @(posedge clock);
    end
        endtask
    task testcase001;

    integer i;
    reg [7:0] miso_pattern;
    begin
        $display("Running testcase001: Basic Write/Read 0xA5...");
        reset_dut();
        miso_pattern = 8'h3C;



        @(posedge clock);
        din = {1'b0, 8'hA5};
        write = 1;
        @(posedge clock);
        write = 0;



        for (i = 0; i < 15; i = i + 1) begin



            if (i < 8) miso = miso_pattern[7-i];
            else miso = 0;
            @(posedge clock);
        end


        repeat(2) @(posedge clock);



        #1;




        check_outputs(1'b1, 8'h3C, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        $display("Running testcase002: All Ones to All Zeros...");
        reset_dut();

        @(posedge clock);
        din = {1'b0, 8'hFF};
        write = 1;
        miso = 0;
        @(posedge clock);
        write = 0;

        repeat(16) @(posedge clock);


        #1;



        check_outputs(1'b1, 8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Idle State Check...");
        reset_dut();


        repeat(10) @(posedge clock);



        if (cs === 1'b1 && sck === 1'b0) begin
            $display("PASS: Idle state correct.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Idle state incorrect. cs=%b sck=%b", cs, sck);
            fail_count = fail_count + 1;
        end
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
        input expected_cs;
        input [7:0] expected_dout;
        input expected_mosi;
        input expected_sck;
        begin
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: cs=%b, dout=%h, mosi=%b, sck=%b",
                         cs, dout, mosi, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%b, dout=%h, mosi=%b, sck=%b",
                         expected_cs, expected_dout, expected_mosi, expected_sck);
                $display("  Got:      cs=%b, dout=%h, mosi=%b, sck=%b",
                         cs, dout, mosi, sck);
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
        $dumpvars(0,clock, din, miso, write, cs, dout, mosi, sck);
    end

endmodule
