`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg nrst;
    reg rd;
    reg reset;
    reg [7:0] wdata;
    reg wr;
    wire empty;
    wire full;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nrst(nrst),
        .rd(rd),
        .reset(reset),
        .wdata(wdata),
        .wr(wr),
        .empty(empty),
        .full(full),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            reset = 1;
            wr = 0;
            rd = 0;
            wdata = 8'h00;
            repeat(2) @(posedge clk);
            #1;
            nrst = 1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, rdata);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single write then single read", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wdata = 8'hAA;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1;
            @(posedge clk);
            rd = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO to check full flag", test_num);
            reset_dut();

            @(posedge clk);
            wr = 1;
            for (i = 0; i < 8; i = i + 1) begin
                wdata = i;
                @(posedge clk);
            end
            wr = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b1, rdata);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking FIFO sequence (0x11, 0x22, 0x33)", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wdata = 8'h11; @(posedge clk);
            wr = 1; wdata = 8'h22; @(posedge clk);
            wr = 1; wdata = 8'h33; @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1; @(posedge clk);
            rd = 1; @(posedge clk);
            rd = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous reset while FIFO has data", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wdata = 8'hFF; @(posedge clk);
            wr = 0;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, rdata);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wdata = 8'h01; @(posedge clk);
            wr = 0;


            @(posedge clk);
            wr = 1; wdata = 8'h02;
            rd = 1;
            @(posedge clk);
            wr = 0;
            rd = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 8'h01);
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
        input [7:0] expected_rdata;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rdata=%h",
                         empty, full, rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rdata=%h",
                         expected_empty, expected_full, expected_rdata);
                $display("  Got:      empty=%b, full=%b, rdata=%h",
                         empty, full, rdata);
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
        $dumpvars(0,clk, nrst, rd, reset, wdata, wr, empty, full, rdata);
    end

endmodule
