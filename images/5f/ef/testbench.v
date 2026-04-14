`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr;
    reg read_en;
    reg reset;
    reg select;
    reg [2:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] q;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .read_en(read_en),
        .reset(reset),
        .select(select),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .q(q),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            select = 0;
            write_en = 0;
            read_en = 0;
            write_addr = 0;
            read_addr = 0;
            write_data = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            select = 1;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(4'h5, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            select = 1;
            repeat(18) @(posedge clk);

            #1;
            #1;

            check_outputs(4'h2, 4'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            select = 0;


            @(posedge clk);
            write_en = 1;
            write_addr = 3'd3;
            write_data = 4'hA;

            @(posedge clk);
            write_en = 0;
            read_en = 1;
            read_addr = 3'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            select = 0;


            @(posedge clk);
            write_en = 1; write_addr = 3'd0; write_data = 4'h1;
            @(posedge clk);
            write_en = 1; write_addr = 3'd7; write_data = 4'hF;


            @(posedge clk);
            write_en = 0; read_en = 1; read_addr = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            select = 1;
            repeat(3) @(posedge clk);

            select = 0;
            @(posedge clk);

            select = 1;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4, 4'h0);
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
        input [3:0] expected_q;
        input [3:0] expected_read_data;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: q=%h, read_data=%h",
                         q, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, read_data=%h",
                         expected_q, expected_read_data);
                $display("  Got:      q=%h, read_data=%h",
                         q, read_data);
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
        $dumpvars(0,clk, read_addr, read_en, reset, select, write_addr, write_data, write_en, q, read_data);
    end

endmodule
