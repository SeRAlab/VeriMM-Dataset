`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] din;
    reg [1:0] rd_addr;
    reg rd_en;
    reg [1:0] wr_addr;
    reg wr_en;
    wire [63:0] dout;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_addr(rd_addr),
        .rd_en(rd_en),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .dout(dout),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            wr_addr = 0;
            rd_addr = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Bank 0...");
            reset_dut();


            din = 64'hFFFF_FFFF_FFFF_ABCD;
            wr_addr = 2'b00;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_addr = 2'b00;
            rd_en = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0000_0000_0000_ABCD, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Bank Access...");
            reset_dut();


            din = 64'h1111; wr_addr = 2'b01; wr_en = 1;
            @(posedge clk); #1;

            din = 64'h3333; wr_addr = 2'b11; wr_en = 1;
            @(posedge clk); #1;
            wr_en = 0;


            rd_addr = 2'b11; rd_en = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h0000_0000_0000_3333, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shifting/LIFO Recent Entry Check...");
            reset_dut();


            din = 64'hAAAA; wr_addr = 2'b10; wr_en = 1;
            @(posedge clk); #1;

            din = 64'hBBBB; wr_addr = 2'b10; wr_en = 1;
            @(posedge clk); #1;
            wr_en = 0;


            rd_addr = 2'b10; rd_en = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(64'h0000_0000_0000_BBBB, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bank Capacity and Full Flag...");
            reset_dut();


            wr_addr = 2'b00;
            wr_en = 1;
            for (i = 0; i < 256; i = i + 1) begin
                din = i;
                @(posedge clk);
                #1;
            end



            #1;




            check_outputs(dout, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Concurrent Read and Write...");
            reset_dut();


            din = 64'h5555; wr_addr = 2'b01; wr_en = 1;
            @(posedge clk); #1;


            din = 64'h6666; wr_addr = 2'b00; wr_en = 1;
            rd_addr = 2'b01; rd_en = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(64'h0000_0000_0000_5555, 0);
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
        input [63:0] expected_dout;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, full=%b",
                         dout, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, full=%b",
                         expected_dout, expected_full);
                $display("  Got:      dout=%h, full=%b",
                         dout, full);
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
        $dumpvars(0,clk, din, rd_addr, rd_en, wr_addr, wr_en, dout, full);
    end

endmodule
