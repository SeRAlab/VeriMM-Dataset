`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [1:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [1:0] data_out;

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
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write 2'b10 to Addr 1 and Read back");
            reset_dut();


            addr = 2'b01;
            data_in = 2'b10;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 2'b11 to Addr 3 and Read back");
            reset_dut();


            addr = 2'b11;
            data_in = 2'b11;
            wr_en = 1;
            rd_en = 0;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Attempt write while wr_en=0");
            reset_dut();


            addr = 2'b10;
            data_in = 2'b01;
            wr_en = 0;
            rd_en = 0;
            @(posedge clk);
            #1;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Read (Addr 0) and Write (Addr 1)");
            reset_dut();


            addr = 2'b00;
            data_in = 2'b01;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 2'b01;
            data_in = 2'b11;
            wr_en = 1;







            @(posedge clk);
            #1;


            addr = 2'b01;
            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting data in Addr 2");
            reset_dut();


            addr = 2'b10;
            data_in = 2'b01;
            wr_en = 1;
            @(posedge clk);
            #1;


            data_in = 2'b11;
            @(posedge clk);
            #1;


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11);
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
        input [1:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
