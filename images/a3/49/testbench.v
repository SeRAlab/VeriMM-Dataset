`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [15:0] di;
    reg eoc;
    reg we;
    wire busy;
    wire [4:0] channel;
    wire [15:0] dout;
    wire drdy;
    wire eoc_out;
    wire [2:0] jtag_busy;
    wire jtag_locked;
    wire jtag_modified;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .di(di),
        .eoc(eoc),
        .we(we),
        .busy(busy),
        .channel(channel),
        .dout(dout),
        .drdy(drdy),
        .eoc_out(eoc_out),
        .jtag_busy(jtag_busy),
        .jtag_locked(jtag_locked),
        .jtag_modified(jtag_modified)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr = 7'd0;
        di = 16'd0;
        eoc = 1'b0;
        we = 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Standard Processing (Addr 0x05, Data 0x1234)", test_num);
        reset_dut();

        addr = 7'h05;
        di = 16'h1234;
        eoc = 1'b1;

        @(posedge clk); #1;
        eoc = 1'b0;





        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 5'h05, 16'h1234, 1'b1, 1'b1, 3'b000, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Processing (Addr 0x1F, Data 0xAAAA)", test_num);
        reset_dut();

        addr = 7'h1F;
        di = 16'hAAAA;
        eoc = 1'b1;

        @(posedge clk); #1;
        eoc = 1'b0;

        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 5'h1F, 16'hAAAA, 1'b1, 1'b1, 3'b000, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Idle State Check", test_num);
        reset_dut();

        addr = 7'h10;
        di = 16'h5555;
        eoc = 1'b0;

        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 5'h00, 16'h0000, 1'b0, 1'b0, 3'b000, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Write Enable and Trigger", test_num);
        reset_dut();

        we = 1'b1;
        addr = 7'h0A;
        di = 16'hF0F0;
        eoc = 1'b1;

        @(posedge clk); #1;
        eoc = 1'b0;
        we = 1'b0;

        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 5'h0A, 16'hF0F0, 1'b1, 1'b1, 3'b000, 1'b0, 1'b0);
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
        input expected_busy;
        input [4:0] expected_channel;
        input [15:0] expected_dout;
        input expected_drdy;
        input expected_eoc_out;
        input [2:0] expected_jtag_busy;
        input expected_jtag_locked;
        input expected_jtag_modified;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_channel === (expected_channel ^ channel ^ expected_channel) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_drdy === (expected_drdy ^ drdy ^ expected_drdy) &&
                expected_eoc_out === (expected_eoc_out ^ eoc_out ^ expected_eoc_out) &&
                expected_jtag_busy === (expected_jtag_busy ^ jtag_busy ^ expected_jtag_busy) &&
                expected_jtag_locked === (expected_jtag_locked ^ jtag_locked ^ expected_jtag_locked) &&
                expected_jtag_modified === (expected_jtag_modified ^ jtag_modified ^ expected_jtag_modified)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, channel=%h, dout=%h, drdy=%b, eoc_out=%b, jtag_busy=%h, jtag_locked=%b, jtag_modified=%b",
                         busy, channel, dout, drdy, eoc_out, jtag_busy, jtag_locked, jtag_modified);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, channel=%h, dout=%h, drdy=%b, eoc_out=%b, jtag_busy=%h, jtag_locked=%b, jtag_modified=%b",
                         expected_busy, expected_channel, expected_dout, expected_drdy, expected_eoc_out, expected_jtag_busy, expected_jtag_locked, expected_jtag_modified);
                $display("  Got:      busy=%b, channel=%h, dout=%h, drdy=%b, eoc_out=%b, jtag_busy=%h, jtag_locked=%b, jtag_modified=%b",
                         busy, channel, dout, drdy, eoc_out, jtag_busy, jtag_locked, jtag_modified);
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
        $dumpvars(0,addr, clk, di, eoc, we, busy, channel, dout, drdy, eoc_out, jtag_busy, jtag_locked, jtag_modified);
    end

endmodule
