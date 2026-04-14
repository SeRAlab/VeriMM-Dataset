`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [7:0] read_addr;
    reg read_en;
    reg reset;
    reg select;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] counter_out;
    wire [7:0] q;
    wire [3:0] ram_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .read_addr(read_addr),
        .read_en(read_en),
        .reset(reset),
        .select(select),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .counter_out(counter_out),
        .q(q),
        .ram_out(ram_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            select = 0;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d = 8'hA5;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h6, 8'hA5, 4'hx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            select = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 8'h03, 4'hx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            write_en = 1;
            write_addr = 8'h12;
            write_data = 4'hC;
            @(posedge clk);
            #1;

            write_en = 0;
            read_en = 1;
            read_addr = 8'h12;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2, 8'h00, 4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d = 8'h0F;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 8'h0F, 4'hx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d = 8'h52;
            select = 1;
            write_en = 1;
            write_addr = 8'h55;
            write_data = 4'h7;
            @(posedge clk);
            write_en = 0;
            read_en = 1;
            read_addr = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4, 8'h02, 4'h7);
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
        input [3:0] expected_counter_out;
        input [7:0] expected_q;
        input [3:0] expected_ram_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_ram_out === (expected_ram_out ^ ram_out ^ expected_ram_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, q=%h, ram_out=%h",
                         counter_out, q, ram_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, q=%h, ram_out=%h",
                         expected_counter_out, expected_q, expected_ram_out);
                $display("  Got:      counter_out=%h, q=%h, ram_out=%h",
                         counter_out, q, ram_out);
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
        $dumpvars(0,clk, d, read_addr, read_en, reset, select, write_addr, write_data, write_en, counter_out, q, ram_out);
    end

endmodule
