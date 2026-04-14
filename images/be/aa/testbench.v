`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg [1:0] rd_en;
    reg [1:0] wr_en;
    wire busy;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            rd_en = 0;
            wr_en = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read (Port 0)...");
            reset_dut();


            addr = 8'h10;
            data_in = 16'hABCD;
            wr_en = 2'b01;
            rd_en = 2'b00;
            @(posedge clk);
            #2;


            wr_en = 2'b00;
            rd_en = 2'b01;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write and Read (Port 1)...");
            reset_dut();


            addr = 8'hFF;
            data_in = 16'h55AA;
            wr_en = 2'b10;
            rd_en = 2'b00;
            @(posedge clk);
            #2;


            wr_en = 2'b00;
            rd_en = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 16'h55AA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Busy signal during Write...");
            reset_dut();

            addr = 8'h20;
            data_in = 16'h1234;
            wr_en = 2'b11;
            rd_en = 2'b00;


            #1;
            #1;

            check_outputs(1'b1, data_out);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Busy signal when idle...");
            reset_dut();

            wr_en = 2'b00;
            rd_en = 2'b00;
            addr = 8'h00;

            #1;

            #1;


            check_outputs(1'b0, data_out);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting existing data...");
            reset_dut();


            addr = 8'h30;
            data_in = 16'hAAAA;
            wr_en = 2'b01;
            @(posedge clk);
            #2;


            data_in = 16'hBBBB;
            wr_en = 2'b01;
            @(posedge clk);
            #2;


            wr_en = 2'b00;
            rd_en = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 16'hBBBB);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Read and Write...");
            reset_dut();


            addr = 8'h40;
            data_in = 16'h7777;
            wr_en = 2'b01;
            rd_en = 2'b10;

            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 16'h7777);
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
        input expected_busy;
        input [15:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, busy, data_out);
    end

endmodule
