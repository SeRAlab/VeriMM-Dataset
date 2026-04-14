`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg nrst;
    reg rd_req;
    reg wr_req;
    wire rd_sta;
    wire wr_sta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nrst(nrst),
        .rd_req(rd_req),
        .wr_req(wr_req),
        .rd_sta(rd_sta),
        .wr_sta(wr_sta)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            wr_req = 0;
            rd_req = 0;
            #15;
            nrst = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset/Idle State");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Write Request Only");
            reset_dut();
            @(negedge clk);
            wr_req = 1;
            rd_req = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Read Request Only");
            reset_dut();
            @(negedge clk);
            wr_req = 0;
            rd_req = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Simultaneous Read and Write");
            reset_dut();
            @(negedge clk);
            wr_req = 1;
            rd_req = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Write Interrupting Read");
            reset_dut();

            @(negedge clk);
            rd_req = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            wr_req = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Release Write to allow Read");
            reset_dut();

            @(negedge clk);
            wr_req = 1;
            rd_req = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            wr_req = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Asynchronous Reset Check");
            reset_dut();
            @(negedge clk);
            wr_req = 1;
            rd_req = 1;
            @(posedge clk);
            #2;

            nrst = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_rd_sta;
        input expected_wr_sta;
        begin
            if (expected_rd_sta === (expected_rd_sta ^ rd_sta ^ expected_rd_sta) &&
                expected_wr_sta === (expected_wr_sta ^ wr_sta ^ expected_wr_sta)) begin
                $display("PASS");
                $display("  Outputs: rd_sta=%b, wr_sta=%b",
                         rd_sta, wr_sta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_sta=%b, wr_sta=%b",
                         expected_rd_sta, expected_wr_sta);
                $display("  Got:      rd_sta=%b, wr_sta=%b",
                         rd_sta, wr_sta);
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
        $dumpvars(0,clk, nrst, rd_req, wr_req, rd_sta, wr_sta);
    end

endmodule
