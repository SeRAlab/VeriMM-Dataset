`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [10:0] read_addr;
    reg read_en;
    reg [10:0] write_addr;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_addr(read_addr),
        .read_en(read_en),
        .write_addr(write_addr),
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
            data_in = 16'h0;
            read_addr = 11'h0;
            read_en = 0;
            write_addr = 11'h0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read...");
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 11'd10;
            data_in = 16'hABCD;
            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 11'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Max Address Test...");
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 11'd2047;
            data_in = 16'hFFFF;
            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 11'd2047;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwrite Test...");
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 11'd55; data_in = 16'h1111;
            @(posedge clk);

            write_addr = 11'd55; data_in = 16'h2222;
            @(posedge clk);
            write_en = 0;


            read_en = 1; read_addr = 11'd55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Simultaneous Dual Port Access...");
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 11'd100; data_in = 16'h7777;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            write_en = 1; write_addr = 11'd200; data_in = 16'h8888;
            read_en = 1;  read_addr = 11'd100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data Persistence Test...");
            reset_dut();


            @(posedge clk);
            write_en = 1; write_addr = 11'd500; data_in = 16'hAAAA;
            @(posedge clk);
            write_en = 0;


            repeat(5) @(posedge clk);


            read_en = 1; read_addr = 11'd500;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_addr, read_en, write_addr, write_en, data_out);
    end

endmodule
