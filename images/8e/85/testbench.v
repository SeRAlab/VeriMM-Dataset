`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            read_en = 0;
            write_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 clear = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write Status", test_num);
            reset_dut();
            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write and Read Data Consistency", test_num);
            reset_dut();

            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;

            #1;


            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill FIFO (256 entries)", test_num);
            reset_dut();
            for (i = 0; i < 256; i = i + 1) begin
                data_in = i[7:0];
                write_en = 1;
                @(posedge clk);
            end
            #1 write_en = 0;

            #1;


            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill and then Empty FIFO", test_num);
            reset_dut();

            for (i = 0; i < 256; i = i + 1) begin
                data_in = i[7:0];
                write_en = 1;
                @(posedge clk);
            end
            #1 write_en = 0;

            for (i = 0; i < 256; i = i + 1) begin
                read_en = 1;
                @(posedge clk);
                #1;
            end
            read_en = 0;

            #1;


            check_outputs(8'hFF, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow Protection", test_num);
            reset_dut();

            for (i = 0; i <= 256; i = i + 1) begin
                data_in = i[7:0];
                write_en = 1;
                @(posedge clk);
            end
            #1 write_en = 0;

            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read/Write", test_num);
            reset_dut();

            data_in = 8'h11;
            write_en = 1;
            @(posedge clk);
            #1;

            data_in = 8'h22;
            write_en = 1;
            read_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;
            read_en = 0;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
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
        testcase007();
        
        
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clear, clk, data_in, read_en, write_en, data_out, empty, full);
    end

endmodule
