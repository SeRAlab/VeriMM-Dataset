`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clr;
    reg [15:0] data_in;
    reg rd_clk;
    reg rd_req;
    reg wr_clk;
    reg wr_req;
    wire [15:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clr(clr),
        .data_in(data_in),
        .rd_clk(rd_clk),
        .rd_req(rd_req),
        .wr_clk(wr_clk),
        .wr_req(wr_req),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

    begin
        clr = 1;
        wr_req = 0;
        rd_req = 0;
        data_in = 0;
        repeat(2) @(posedge wr_clk);
        repeat(2) @(posedge rd_clk);
        #1 clr = 0;
        repeat(2) @(posedge wr_clk);
        repeat(2) @(posedge rd_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(16'hzzzz, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Write/Read", test_num);
        reset_dut();


        @(posedge wr_clk);
        wr_req = 1;
        data_in = 16'hABCD;
        @(posedge wr_clk);
        wr_req = 0;


        repeat(5) @(posedge rd_clk);
        rd_req = 1;
        @(posedge rd_clk);
        rd_req = 0;


        #1 #1;
 check_outputs(16'hABCD, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Fill FIFO to Full", test_num);
        reset_dut();


        for (i = 0; i < 64; i = i + 1) begin
            @(posedge wr_clk);
            wr_req = 1;
            data_in = i[15:0];
        end
        @(posedge wr_clk);
        wr_req = 0;


        repeat(5) @(posedge wr_clk);


        #1;



        check_outputs(16'h0000, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Fill and Empty FIFO", test_num);
        reset_dut();


        for (i = 0; i < 64; i = i + 1) begin
            @(posedge wr_clk);
            wr_req = 1;
            data_in = i[15:0];
        end
        @(posedge wr_clk);
        wr_req = 0;


        repeat(5) @(posedge rd_clk);
        for (i = 0; i < 64; i = i + 1) begin
            @(posedge rd_clk);
            rd_req = 1;
        end
        @(posedge rd_clk);
        rd_req = 0;


        repeat(5) @(posedge rd_clk);

        #1;


        check_outputs(16'h003F, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Clear Operation", test_num);
        reset_dut();


        for (i = 0; i < 10; i = i + 1) begin
            @(posedge wr_clk);
            wr_req = 1;
            data_in = 16'h55AA;
        end
        @(posedge wr_clk);
        wr_req = 0;


        repeat(2) @(posedge wr_clk);
        clr = 1;
        repeat(2) @(posedge wr_clk);
        clr = 0;
        repeat(5) @(posedge rd_clk);


        #1;



        check_outputs(16'hxxxx, 1'b1, 1'b0);
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
        $dumpvars(0,clr, data_in, rd_clk, rd_req, wr_clk, wr_req, data_out, empty, full);
    end

endmodule
