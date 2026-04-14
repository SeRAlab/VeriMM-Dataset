`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] din;
    reg rd_clk;
    reg rd_en;
    reg rst;
    reg wr_clk;
    reg wr_en;
    wire [31:0] dout;
    wire empty;
    wire full;
    wire [9:0] wr_data_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full),
        .wr_data_count(wr_data_count)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            wr_en = 0;
            rd_en = 0;
            repeat (5) @(posedge wr_clk);
            rst = 0;
            repeat (5) @(posedge wr_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Single Write and Read", test_num);
            reset_dut();


            @(posedge wr_clk);
            din = 32'hAAAA_BBBB;
            wr_en = 1;
            @(posedge wr_clk);
            wr_en = 0;


            repeat (10) @(posedge rd_clk);


            @(posedge rd_clk);
            rd_en = 1;
            @(posedge rd_clk);
            rd_en = 0;


            #1;



            check_outputs(32'hAAAA_BBBB, 1'b1, 1'b0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Fill to Full", test_num);
            reset_dut();


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge wr_clk);
                din = i;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 0;


            repeat (10) @(posedge wr_clk);



            #1;




            check_outputs(dout, 1'b0, 1'b1, 10'd511);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill and then Empty", test_num);
            reset_dut();


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge wr_clk);
                din = i + 32'h100;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 0;

            repeat (10) @(posedge rd_clk);


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge rd_clk);
                rd_en = 1;
            end
            @(posedge rd_clk);
            rd_en = 0;

            repeat (10) @(posedge wr_clk);


            #1;



            check_outputs(32'h100 + 511, 1'b1, 1'b0, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Count Tracking", test_num);
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                @(posedge wr_clk);
                din = i;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 0;

            repeat (10) @(posedge wr_clk);


            #1;



            check_outputs(dout, 1'b0, 1'b0, 10'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overflow and Underflow", test_num);
            reset_dut();


            @(posedge rd_clk);
            rd_en = 1;
            @(posedge rd_clk);
            rd_en = 0;


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge wr_clk);
                din = 32'hFFFF_FFFF;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 1;
            din = 32'hEEEE_EEEE;
            @(posedge wr_clk);
            wr_en = 0;

            repeat (10) @(posedge wr_clk);


            #1;



            check_outputs(dout, 1'b0, 1'b1, 10'd511);
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
        input [31:0] expected_dout;
        input expected_empty;
        input expected_full;
        input [9:0] expected_wr_data_count;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_wr_data_count === (expected_wr_data_count ^ wr_data_count ^ expected_wr_data_count)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, wr_data_count=%h",
                         dout, empty, full, wr_data_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, wr_data_count=%h",
                         expected_dout, expected_empty, expected_full, expected_wr_data_count);
                $display("  Got:      dout=%h, empty=%b, full=%b, wr_data_count=%h",
                         dout, empty, full, wr_data_count);
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
        $dumpvars(0,din, rd_clk, rd_en, rst, wr_clk, wr_en, dout, empty, full, wr_data_count);
    end

endmodule
