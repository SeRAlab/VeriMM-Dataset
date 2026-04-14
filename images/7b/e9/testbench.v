`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_req;
    reg [7:0] wr_data;
    reg wr_req;
    wire [7:0] rd_data;
    wire wr_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_req(rd_req),
        .wr_data(wr_data),
        .wr_req(wr_req),
        .rd_data(rd_data),
        .wr_ack(wr_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd_req = 0;
            wr_req = 0;
            wr_data = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            wr_req = 1;
            wr_data = 8'hA5;
            @(posedge clk);
            wr_req = 0;


            rd_req = 1;
            @(posedge clk);
            rd_req = 0;
            @(posedge clk);

            #1;
            $display("Test Case 001: Basic Write/Read");
            #1;

            check_outputs(8'hA5, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                wr_req = 1;
                wr_data = i;
            end
            @(posedge clk);
            wr_req = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                rd_req = 1;
            end
            @(posedge clk);
            rd_req = 0;
            @(posedge clk);

            #1;
            $display("Test Case 002: Capacity Test (8 slots)");
            #1;

            check_outputs(8'd8, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            wr_req = 1; wr_data = 8'h11;
            @(posedge clk);
            wr_req = 1; wr_data = 8'h22;
            @(posedge clk);
            wr_req = 0;


            rd_req = 1;
            @(posedge clk);


            rd_req = 0;
            wr_req = 1; wr_data = 8'h33;
            @(posedge clk);
            wr_req = 0;


            rd_req = 1;
            @(posedge clk);

            rd_req = 1;
            @(posedge clk);
            rd_req = 0;
            @(posedge clk);

            #1;
            $display("Test Case 003: Order Verification");
            #1;

            check_outputs(8'h33, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            for (i = 1; i <= 10; i = i + 1) begin
                @(posedge clk);
                wr_req = 1;
                wr_data = i;
            end
            @(posedge clk);
            wr_req = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                rd_req = 1;
            end
            @(posedge clk);
            rd_req = 0;
            @(posedge clk);

            #1;
            $display("Test Case 004: Overflow Test (Write 10, Read 8)");


            #1;



            check_outputs(8'd8, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                wr_req = 1; wr_data = i;
            end
            @(posedge clk);
            wr_req = 0;


            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                rd_req = 1;
            end
            @(posedge clk);
            rd_req = 0;


            for (i = 10; i <= 15; i = i + 1) begin
                @(posedge clk);
                wr_req = 1; wr_data = i;
            end
            @(posedge clk);
            wr_req = 0;


            for (i = 1; i <= 6; i = i + 1) begin
                @(posedge clk);
                rd_req = 1;
            end
            @(posedge clk);
            rd_req = 0;
            @(posedge clk);

            #1;
            $display("Test Case 005: Pointer Wrap Around");
            #1;

            check_outputs(8'd15, 0);
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
        input [7:0] expected_rd_data;
        input expected_wr_ack;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data) &&
                expected_wr_ack === (expected_wr_ack ^ wr_ack ^ expected_wr_ack)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h, wr_ack=%b",
                         rd_data, wr_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h, wr_ack=%b",
                         expected_rd_data, expected_wr_ack);
                $display("  Got:      rd_data=%h, wr_ack=%b",
                         rd_data, wr_ack);
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
        $dumpvars(0,clk, rd_req, wr_data, wr_req, rd_data, wr_ack);
    end

endmodule
