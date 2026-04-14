`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg rst;
    reg [7:0] wr_data;
    reg wr_en;
    wire empty;
    wire full;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rd_en = 0;
            wr_en = 0;
            wr_data = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Reset State");

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Single Write Status");
            wr_en = 1;
            wr_data = 8'hAA;
            @(posedge clk);
            #1;
            wr_en = 0;

            #1;


            check_outputs(1'b0, 1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Single Write-Read Cycle");

            wr_en = 1;
            wr_data = 8'h55;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h55);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Fill to Full Capacity");
            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                wr_data = i + 1;
                @(posedge clk);
                #1;
            end
            wr_en = 0;

            #1;


            check_outputs(1'b0, 1'b1, 8'h01);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Full Fill and Full Drain");

            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                wr_data = 8'hA0 + i;
                @(posedge clk);
                #1;
            end
            wr_en = 0;

            rd_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            rd_en = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'hA7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Simultaneous Read and Write");

            wr_en = 1;
            wr_data = 8'h11;
            @(posedge clk);
            #1;

            wr_data = 8'h22;
            rd_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;

            #1;


            check_outputs(1'b0, 1'b0, 8'h11);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Overflow Protection");
            wr_en = 1;

            for (i = 0; i < 10; i = i + 1) begin
                wr_data = i;
                @(posedge clk);
                #1;
            end
            wr_en = 0;

            #1;


            check_outputs(1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase 008: Underflow Protection");

            rd_en = 1;
            repeat(2) @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_rd_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_data=%h",
                         expected_empty, expected_full, expected_rd_data);
                $display("  Got:      empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
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
        $dumpvars(0,clk, rd_en, rst, wr_data, wr_en, empty, full, rd_data);
    end

endmodule
