`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [4:0] data_count;
    wire [127:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .data_count(data_count),
        .dout(dout),
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
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0, 128'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write", test_num);
            reset_dut();
            @(posedge clk);
            din = 128'hCAFE_BABE_DEAD_BEEF_0000_1111_2222_3333;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;
            din = 0;
            @(posedge clk);


            #1;



            check_outputs(5'd1, 128'hCAFE_BABE_DEAD_BEEF_0000_1111_2222_3333, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write then Read", test_num);
            reset_dut();
            @(posedge clk);
            din = 128'h5555_AAAA_5555_AAAA_1234_5678_9ABC_DEF0;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd0, 128'h5555_AAAA_5555_AAAA_1234_5678_9ABC_DEF0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill to Full", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd16, 128'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Fill then Empty", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end
            @(posedge clk);
            wr_en = 0;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd0, 128'd15, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Protection", test_num);
            reset_dut();

            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd16, 128'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();

            @(posedge clk);
            wr_en = 1;
            din = 128'h1;
            @(posedge clk);

            wr_en = 1;
            din = 128'h2;
            rd_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd1, 128'h2, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Underflow Protection", test_num);
            reset_dut();

            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(5'd0, 128'h0, 1'b1, 1'b0);
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
        testcase008();
        
        
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
        input [4:0] expected_data_count;
        input [127:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_count === (expected_data_count ^ data_count ^ expected_data_count) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_count=%h, dout=%h, empty=%b, full=%b",
                         data_count, dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_count=%h, dout=%h, empty=%b, full=%b",
                         expected_data_count, expected_dout, expected_empty, expected_full);
                $display("  Got:      data_count=%h, dout=%h, empty=%b, full=%b",
                         data_count, dout, empty, full);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, data_count, dout, empty, full);
    end

endmodule
