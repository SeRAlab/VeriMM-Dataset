`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Basic Single Write and Read");
            reset_dut();


            data_in = 8'hA5;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 1);
            rd_en = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: FIFO Ordering (Multiple Items)");
            reset_dut();


            data_in = 8'h11; wr_en = 1; @(posedge clk);
            data_in = 8'h22; wr_en = 1; @(posedge clk);
            data_in = 8'h33; wr_en = 1; @(posedge clk);
            wr_en = 0;


            rd_en = 1; @(posedge clk);
            rd_en = 1; @(posedge clk);
            rd_en = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33, 1);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Read from Empty FIFO");
            reset_dut();

            rd_en = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 0);
            rd_en = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Simultaneous Write and Read");
            reset_dut();


            data_in = 8'h77; wr_en = 1; @(posedge clk);
            wr_en = 0;


            data_in = 8'h88; wr_en = 1; rd_en = 1; @(posedge clk);
            wr_en = 0; rd_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h88, 1);
            rd_en = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Full Sequence");
            reset_dut();


            data_in = 8'hD1; wr_en = 1; @(posedge clk);
            data_in = 8'hD2; wr_en = 1; @(posedge clk);
            data_in = 8'hD3; wr_en = 1; @(posedge clk);
            data_in = 8'hD4; wr_en = 1; @(posedge clk);
            wr_en = 0;


            rd_en = 1; @(posedge clk);
            rd_en = 1; @(posedge clk);
            rd_en = 1; @(posedge clk);
            rd_en = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(8'hD4, 1);
            rd_en = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Reset Effectiveness");
            reset_dut();


            data_in = 8'hFF; wr_en = 1; @(posedge clk);
            wr_en = 0;


            reset_dut();


            rd_en = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(data_out, 0);
            rd_en = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
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
        input [7:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out, valid);
    end

endmodule
