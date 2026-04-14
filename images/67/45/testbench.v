`timescale 1ns/1ps

module sync_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [15:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_fifo dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
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
            @(negedge clk);
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge clk);
            wr_en = 1;
            data_in = 16'hDEAD;
            @(negedge clk);
            wr_en = 0;


            @(negedge clk);
            rd_en = 1;
            @(negedge clk);
            rd_en = 0;


            #1;



            check_outputs(16'hDEAD, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();

            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                wr_en = 1;
                data_in = i[15:0];
            end
            @(negedge clk);
            wr_en = 0;


            #1;



            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                wr_en = 1;
                data_in = i[15:0];
            end
            @(negedge clk);
            wr_en = 0;


            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                rd_en = 1;
            end
            @(negedge clk);
            rd_en = 0;


            #1;



            check_outputs(16'h001F, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                wr_en = 1;
                data_in = 16'hAAAA;
            end

            @(negedge clk);
            wr_en = 1;
            data_in = 16'hFFFF;
            @(negedge clk);
            wr_en = 0;


            #1;



            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(negedge clk);
            rd_en = 1;
            @(negedge clk);
            rd_en = 0;


            #1;



            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            @(negedge clk);
            wr_en = 1; data_in = 16'h1111;
            @(negedge clk);
            wr_en = 0;


            @(negedge clk);
            wr_en = 1; data_in = 16'h2222;
            rd_en = 1;
            @(negedge clk);
            wr_en = 0; rd_en = 0;


            #1;



            check_outputs(16'h1111, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_fifo Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out, empty, full);
    end

endmodule
