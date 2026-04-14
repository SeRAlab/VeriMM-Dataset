`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] din;
    reg rd_clk;
    reg rd_en;
    reg rst;
    reg wr_clk;
    reg wr_en;
    wire almost_empty;
    wire almost_full;
    wire [63:0] dout;
    wire empty;
    wire full;
    wire prog_empty;
    wire prog_full;

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
        .almost_empty(almost_empty),
        .almost_full(almost_full),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_empty(prog_empty),
        .prog_full(prog_full)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

    begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        repeat(5) @(posedge wr_clk);
        rst = 0;
        repeat(5) @(posedge wr_clk);
    end
        endtask
    task write_data;

        input [63:0] data;
        begin
            @(posedge wr_clk);
            wr_en <= 1;
            din <= data;
            @(posedge wr_clk);
            wr_en <= 0;
            din <= 0;
        end
        endtask

    task read_data;

        begin
            @(posedge rd_clk);
            rd_en <= 1;
            @(posedge rd_clk);
            rd_en <= 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial State", test_num);
        reset_dut();

        repeat(10) @(posedge rd_clk);

        #1;


        check_outputs(1'b1, 1'b0, 64'h0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Word Write/Read", test_num);
        reset_dut();
        write_data(64'hDEADBEEFCAFEBABE);
        repeat(10) @(posedge rd_clk);
        read_data();
        repeat(5) @(posedge rd_clk);

        #1;


        check_outputs(1'b1, 1'b0, 64'hDEADBEEFCAFEBABE, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Fill to Full (512 words)", test_num);
        reset_dut();
        for(i=0; i<512; i=i+1) begin
            write_data(i);
        end
        repeat(10) @(posedge wr_clk);


        #1;



        check_outputs(1'b0, 1'b1, 64'h0, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Read until Empty", test_num);
        reset_dut();

        for(i=0; i<512; i=i+1) begin
            write_data(i + 64'h100);
        end
        repeat(10) @(posedge rd_clk);

        for(i=0; i<512; i=i+1) begin
            read_data();
        end
        repeat(10) @(posedge rd_clk);

        #1;


        check_outputs(1'b1, 1'b0, 64'h1FF, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Half Full Status", test_num);
        reset_dut();

        for(i=0; i<256; i=i+1) begin
            write_data(i);
        end
        repeat(10) @(posedge rd_clk);



        #1;




        check_outputs(1'b0, 1'b0, 64'h0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_almost_empty;
        input expected_almost_full;
        input [63:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_prog_empty;
        input expected_prog_full;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_prog_empty === (expected_prog_empty ^ prog_empty ^ expected_prog_empty) &&
                expected_prog_full === (expected_prog_full ^ prog_full ^ expected_prog_full)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, almost_full=%b, dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b",
                         almost_empty, almost_full, dout, empty, full, prog_empty, prog_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, almost_full=%b, dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b",
                         expected_almost_empty, expected_almost_full, expected_dout, expected_empty, expected_full, expected_prog_empty, expected_prog_full);
                $display("  Got:      almost_empty=%b, almost_full=%b, dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b",
                         almost_empty, almost_full, dout, empty, full, prog_empty, prog_full);
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
        $dumpvars(0,din, rd_clk, rd_en, rst, wr_clk, wr_en, almost_empty, almost_full, dout, empty, full, prog_empty, prog_full);
    end

endmodule
