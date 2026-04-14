`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire empty;
    wire full;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .input_data(input_data),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .output_data(output_data)
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
        input_data = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0, 8'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Write and Read", test_num);
        reset_dut();


        wr_en = 1;
        input_data = 8'hAA;
        @(posedge clk);
        #1 wr_en = 0;


        rd_en = 1;
        @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'hAA);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %03d: Fill FIFO to Full", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            input_data = i + 1;
            @(posedge clk);
        end
        #1 wr_en = 0;



        #1;




        check_outputs(1'b0, 1'b1, 8'h01);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Fill then Empty FIFO", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            input_data = 8'hA0 + i;
            @(posedge clk);
        end
        #1 wr_en = 0;


        rd_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
        end
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'hA7);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %03d: Write to Full FIFO (Overflow Check)", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            input_data = i;
            @(posedge clk);
        end

        input_data = 8'hFF;
        @(posedge clk);
        #1 wr_en = 0;



        #1;




        check_outputs(1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Simultaneous Read and Write", test_num);
        reset_dut();


        wr_en = 1;
        input_data = 8'h11;
        @(posedge clk);
        #1 wr_en = 0;


        wr_en = 1;
        rd_en = 1;
        input_data = 8'h22;
        @(posedge clk);
        #1 wr_en = 0;
        rd_en = 0;


        rd_en = 1;
        @(posedge clk);
        #1 rd_en = 0;


        #1;



        check_outputs(1'b1, 1'b0, 8'h22);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_output_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, output_data=%h",
                         empty, full, output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, output_data=%h",
                         expected_empty, expected_full, expected_output_data);
                $display("  Got:      empty=%b, full=%b, output_data=%h",
                         empty, full, output_data);
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
        $dumpvars(0,clk, input_data, rd_en, rst, wr_en, empty, full, output_data);
    end

endmodule
