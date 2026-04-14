`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg reset;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        write_en = 0;
        read_en = 0;
        data_in = 0;
        test_num = test_num + 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Single Write/Read");

        @(posedge clk);
        write_en <= 1;
        data_in <= 8'hA5;
        @(posedge clk);
        write_en <= 0;

        @(posedge clk);
        read_en <= 1;
        @(posedge clk);
        read_en <= 0;

        #1 #1;
 check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Multiple Writes/Reads (FIFO Order)");

        @(posedge clk);
        write_en <= 1; data_in <= 8'h11;
        @(posedge clk);
        write_en <= 1; data_in <= 8'h22;
        @(posedge clk);
        write_en <= 1; data_in <= 8'h33;
        @(posedge clk);
        write_en <= 0;

        @(posedge clk);
        read_en <= 1;
        @(posedge clk);
        read_en <= 1;
        @(posedge clk);
        read_en <= 1;
        @(posedge clk);
        read_en <= 0;

        #1 #1;
 check_outputs(8'h33);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Interleaved Operation");

        @(posedge clk);
        write_en <= 1; data_in <= 8'hDE;
        @(posedge clk);
        write_en <= 0; read_en <= 1;
        @(posedge clk);
        read_en <= 0; write_en <= 1; data_in <= 8'hAD;
        @(posedge clk);
        write_en <= 0; read_en <= 1;
        @(posedge clk);
        read_en <= 0;

        #1 #1;
 check_outputs(8'hAD);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        $display("Testcase 004: Burst Write/Read");

        for(i=0; i<8; i=i+1) begin
            @(posedge clk);
            write_en <= 1;
            data_in <= i[7:0] + 8'h10;
        end
        @(posedge clk);
        write_en <= 0;

        for(i=0; i<8; i=i+1) begin
            @(posedge clk);
            read_en <= 1;
        end
        @(posedge clk);
        read_en <= 0;

        #1 #1;
 check_outputs(8'h10 + 7);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Reset Persistence");


        @(posedge clk);
        write_en <= 1; data_in <= 8'hFF;
        @(posedge clk);
        write_en <= 0;


        reset_dut();


        @(posedge clk);
        write_en <= 1; data_in <= 8'h55;
        @(posedge clk);
        write_en <= 0;

        @(posedge clk);
        read_en <= 1;
        @(posedge clk);
        read_en <= 0;

        #1 #1;
 check_outputs(8'h55);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_en, reset, write_en, data_out);
    end

endmodule
