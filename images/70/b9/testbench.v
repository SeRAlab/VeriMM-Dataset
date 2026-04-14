`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [7:0] wr_data;
    wire empty;
    wire full;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd(rd),
        .reset_n(reset_n),
        .wr(wr),
        .wr_data(wr_data),
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
            reset_n = 0;
            wr = 0;
            rd = 0;
            wr_data = 0;
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check...");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, rd_data);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write-Read...");
            reset_dut();


            wr = 1; wr_data = 8'hA5;
            @(posedge clk);
            wr = 0;


            rd = 1;
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(1'b1, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill to capacity (8 elements)...");
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                wr = 1; wr_data = i + 1;
                @(posedge clk);
            end
            #1 wr = 0;


            #1;



            check_outputs(1'b0, 1'b1, rd_data);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Emptying from full state...");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                wr = 1; wr_data = 8'h10 + i;
                @(posedge clk);
            end
            wr = 0;


            for (i = 0; i < 8; i = i + 1) begin
                rd = 1;
                @(posedge clk);
            end
            #1 rd = 0;


            #1;



            check_outputs(1'b1, 1'b0, 8'h17);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Overflow protection check...");
            reset_dut();


            wr = 1;
            for (i = 0; i < 10; i = i + 1) begin
                wr_data = i;
                @(posedge clk);
            end
            #1 wr = 0;


            #1;



            check_outputs(1'b0, 1'b1, rd_data);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Underflow protection check...");
            reset_dut();


            rd = 1;
            @(posedge clk);
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(1'b1, 1'b0, rd_data);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Simultaneous Read and Write...");
            reset_dut();


            wr = 1; wr_data = 8'hCC;
            @(posedge clk);


            wr = 1; wr_data = 8'hDD;
            rd = 1;
            @(posedge clk);
            #1 wr = 0; rd = 0;



            #1;




            check_outputs(1'b0, 1'b0, 8'hCC);
        end
        endtask

    task testcase008;

        integer i;
        begin
            $display("Running testcase008: Pointer wrap-around check...");
            reset_dut();


            wr = 1;
            for (i = 0; i < 5; i = i + 1) begin
                wr_data = i;
                @(posedge clk);
            end
            wr = 0;


            rd = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            rd = 0;


            wr = 1;
            for (i = 0; i < 5; i = i + 1) begin
                wr_data = 8'hAA + i;
                @(posedge clk);
            end
            wr = 0;


            rd = 1;
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(1'b0, 1'b0, 8'hAA);
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
        $dumpvars(0,clk, rd, reset_n, wr, wr_data, empty, full, rd_data);
    end

endmodule
