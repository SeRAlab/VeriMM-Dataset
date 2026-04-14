`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg p_18_out;
    reg rd_clk;
    reg rd_en;
    reg rst;
    reg wr_clk;
    wire [31:0] Q;
    wire rst_full_ff_i;
    wire rst_full_gen_i;
    wire tmp_ram_rd_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p_18_out(p_18_out),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .Q(Q),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i),
        .tmp_ram_rd_en(tmp_ram_rd_en)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rd_en = 0;
            p_18_out = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset Check", test_num);
            reset_dut();
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(Q, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Simple Write/Read", test_num);
            reset_dut();


            @(posedge wr_clk);
            p_18_out = 1;
            @(posedge wr_clk);
            p_18_out = 0;


            repeat(8) @(posedge rd_clk);


            rd_en = 1;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(Q, 1'b0, 1'b0, 1'b1);

            @(posedge rd_clk);
            rd_en = 0;
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Fill FIFO to Full", test_num);
            reset_dut();


            for (i = 0; i < 4096; i = i + 1) begin
                @(posedge wr_clk);
                p_18_out = 1;
            end
            @(posedge wr_clk);
            p_18_out = 0;


            repeat(5) @(posedge wr_clk);
            #1;

            if (rst_full_ff_i === 1'b1 || rst_full_gen_i === 1'b1) begin
                $display("PASS: Full flag detected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Full flag NOT detected after 4096 writes");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Read Empty Check", test_num);
            reset_dut();

            @(posedge rd_clk);
            rd_en = 1;
            @(posedge rd_clk);
            #1;

            #1;


            check_outputs(Q, 1'b0, 1'b0, 1'b0);
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_Q;
        input expected_rst_full_ff_i;
        input expected_rst_full_gen_i;
        input expected_tmp_ram_rd_en;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_rst_full_ff_i === (expected_rst_full_ff_i ^ rst_full_ff_i ^ expected_rst_full_ff_i) &&
                expected_rst_full_gen_i === (expected_rst_full_gen_i ^ rst_full_gen_i ^ expected_rst_full_gen_i) &&
                expected_tmp_ram_rd_en === (expected_tmp_ram_rd_en ^ tmp_ram_rd_en ^ expected_tmp_ram_rd_en)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, rst_full_ff_i=%b, rst_full_gen_i=%b, tmp_ram_rd_en=%b",
                         Q, rst_full_ff_i, rst_full_gen_i, tmp_ram_rd_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, rst_full_ff_i=%b, rst_full_gen_i=%b, tmp_ram_rd_en=%b",
                         expected_Q, expected_rst_full_ff_i, expected_rst_full_gen_i, expected_tmp_ram_rd_en);
                $display("  Got:      Q=%h, rst_full_ff_i=%b, rst_full_gen_i=%b, tmp_ram_rd_en=%b",
                         Q, rst_full_ff_i, rst_full_gen_i, tmp_ram_rd_en);
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
        $dumpvars(0,p_18_out, rd_clk, rd_en, rst, wr_clk, Q, rst_full_ff_i, rst_full_gen_i, tmp_ram_rd_en);
    end

endmodule
