`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rd;
    reg reset;
    reg wr;
    wire [15:0] data_out;
    wire empty;
    wire full;
    wire last;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .last(last)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rd = 0;
            wr = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            wr = 1; data_in = 16'hABCD;
            @(posedge clk);
            #1 wr = 0;
            @(posedge clk);

            #1 rd = 1;
            @(posedge clk);
            #1 rd = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                wr = 1; data_in = i;
                @(posedge clk);
            end
            #1 wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            wr = 1; data_in = 16'h1111; @(posedge clk);
            data_in = 16'h2222; @(posedge clk);
            data_in = 16'h3333; @(posedge clk);
            #1 wr = 0;
            @(posedge clk);

            #1 rd = 1; @(posedge clk);

            @(posedge clk);

            @(posedge clk);
            #1 rd = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h3333, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            wr = 1; data_in = 16'h5555;
            @(posedge clk);
            #1 wr = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            wr = 1; data_in = 16'hAAAA;
            @(posedge clk);
            #1 wr = 1; rd = 1; data_in = 16'hBBBB;
            @(posedge clk);
            #1 wr = 0; rd = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 1'b0, 1'b0, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_empty;
        input expected_full;
        input expected_last;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_last === (expected_last ^ last ^ expected_last)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b, last=%b",
                         data_out, empty, full, last);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b, last=%b",
                         expected_data_out, expected_empty, expected_full, expected_last);
                $display("  Got:      data_out=%h, empty=%b, full=%b, last=%b",
                         data_out, empty, full, last);
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
        $dumpvars(0,clk, data_in, rd, reset, wr, data_out, empty, full, last);
    end

endmodule
