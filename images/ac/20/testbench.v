`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg rst;
    reg [31:0] wr_data;
    reg wr_en;
    wire empty;
    wire full;
    wire [31:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            wr_en = 0;
            rd_en = 0;
            wr_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking reset state...");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 32'hX);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Single Read...");
            reset_dut();


            wr_en = 1;
            wr_data = 32'hABCDE123;
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 32'hABCDE123);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Write and Read (Ordering Check)...");
            reset_dut();


            wr_en = 1; wr_data = 32'h11111111; @(posedge clk);
            wr_en = 1; wr_data = 32'h22222222; @(posedge clk);
            wr_en = 0;
            @(posedge clk);


            rd_en = 1; @(posedge clk);
            rd_en = 0; @(posedge clk);


            rd_en = 1; @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 32'h22222222);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill FIFO to check Full Flag...");
            reset_dut();

            wr_en = 1;

            for (i = 0; i < 16; i = i + 1) begin
                wr_data = i;
                @(posedge clk);
            end
            wr_en = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b1, rd_data);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Read and Write...");
            reset_dut();


            wr_en = 1; wr_data = 32'h77777777; @(posedge clk);
            wr_en = 0; @(posedge clk);


            wr_en = 1; wr_data = 32'h88888888;
            rd_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 32'h77777777);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Pointer Wrap-around Check...");
            reset_dut();


            wr_en = 1;
            for(i=0; i<4; i=i+1) begin
                wr_data = i + 10;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for(i=0; i<4; i=i+1) begin
                @(posedge clk);
            end
            rd_en = 0;


            wr_en = 1; wr_data = 32'hFFFFFFFF; @(posedge clk);
            wr_en = 0; @(posedge clk);


            rd_en = 1; @(posedge clk);
            rd_en = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 32'hFFFFFFFF);
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
        input [31:0] expected_rd_data;
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
