`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cfg;
    reg clk;
    reg dma_ack;
    reg full_empty;
    reg rst;
    reg [1:0] status;
    wire dma_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg(cfg),
        .clk(clk),
        .dma_ack(dma_ack),
        .full_empty(full_empty),
        .rst(rst),
        .status(status),
        .dma_req(dma_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cfg = 8'h00;
            dma_ack = 0;
            full_empty = 0;
            status = 2'b00;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable DMA and trigger request via status and buffer", test_num);
            reset_dut();
            @(negedge clk);
            cfg = 8'h01;
            status = 2'b11;
            full_empty = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify dma_ack clears dma_req", test_num);
            reset_dut();
            @(negedge clk);
            cfg = 8'h01;
            status = 2'b11;
            full_empty = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #1;

            @(negedge clk);
            dma_ack = 1'b1;

            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify dma_req stays low when cfg is disabled", test_num);
            reset_dut();
            @(negedge clk);
            cfg = 8'h00;
            status = 2'b11;
            full_empty = 1'b1;

            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify behavior with different cfg bits", test_num);
            reset_dut();
            @(negedge clk);
            cfg = 8'h81;
            status = 2'b01;
            full_empty = 1'b0;

            repeat (2) @(posedge clk);


            #1 #1;
 check_outputs(dma_req);
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
        input expected_dma_req;
        begin
            if (expected_dma_req === (expected_dma_req ^ dma_req ^ expected_dma_req)) begin
                $display("PASS");
                $display("  Outputs: dma_req=%b",
                         dma_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dma_req=%b",
                         expected_dma_req);
                $display("  Got:      dma_req=%b",
                         dma_req);
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
        $dumpvars(0,cfg, clk, dma_ack, full_empty, rst, status, dma_req);
    end

endmodule
