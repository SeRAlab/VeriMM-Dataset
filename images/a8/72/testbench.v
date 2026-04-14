`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
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
        rst = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial State Check", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Write and Read", test_num);
        reset_dut();


        wr_en = 1;
        data_in = 8'hA5;
        @(posedge clk);
        #1 wr_en = 0;


        rd_en = 1;
        @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(8'hA5, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %0d: Fill FIFO to Full", test_num);
        reset_dut();


        for (i = 0; i < 16; i = i + 1) begin
            wr_en = 1;
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 0;


        #1;



        check_outputs(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    reg [7:0] last_data;
    begin
        test_num = 4;
        $display("Testcase %0d: Fill and Empty FIFO", test_num);
        reset_dut();


        for (i = 0; i < 16; i = i + 1) begin
            wr_en = 1;
            data_in = i[7:0] + 8'h10;
            @(posedge clk);
            #1;
        end
        wr_en = 0;


        for (i = 0; i < 16; i = i + 1) begin
            rd_en = 1;
            @(posedge clk);
            last_data = data_out;
            #1;
        end
        rd_en = 0;


        #1;



        check_outputs(8'h1F, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %0d: Overflow Check", test_num);
        reset_dut();


        for (i = 0; i < 20; i = i + 1) begin
            wr_en = 1;
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 0;


        #1;



        check_outputs(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Underflow Check", test_num);
        reset_dut();


        repeat(5) begin
            rd_en = 1;
            @(posedge clk);
            #1;
        end
        rd_en = 0;


        #1;



        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Simultaneous Read/Write", test_num);
        reset_dut();


        wr_en = 1;
        data_in = 8'h55;
        @(posedge clk);
        #1 wr_en = 0;


        wr_en = 1;
        data_in = 8'hAA;
        rd_en = 1;
        @(posedge clk);
        #1;
        wr_en = 0;
        rd_en = 0;


        #1;



        check_outputs(8'h55, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out, empty, full);
    end

endmodule
