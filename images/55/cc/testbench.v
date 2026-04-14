`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg cpl_pending_dmard;
    reg cpl_pending_dmawr;
    reg rstn;
    reg tx_ack0;
    reg [127:0] tx_desc0;
    wire [6:0] cpl_err;
    wire cpl_pending;
    wire [127:0] err_desc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .cpl_pending_dmard(cpl_pending_dmard),
        .cpl_pending_dmawr(cpl_pending_dmawr),
        .rstn(rstn),
        .tx_ack0(tx_ack0),
        .tx_desc0(tx_desc0),
        .cpl_err(cpl_err),
        .cpl_pending(cpl_pending),
        .err_desc(err_desc)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rstn = 0;
            cpl_pending_dmard = 0;
            cpl_pending_dmawr = 0;
            tx_ack0 = 0;
            tx_desc0 = 128'h0;
            repeat(5) @(posedge clk_in);
            rstn = 1;
            repeat(1) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(7'h00, 1'b0, 128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DMA Write Pending Monitoring", test_num);
            reset_dut();
            @(posedge clk_in);
            cpl_pending_dmawr = 1'b1;
            repeat(2) @(posedge clk_in);

            #1;


            check_outputs(7'h00, 1'b1, 128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DMA Read Pending Monitoring", test_num);
            reset_dut();
            @(posedge clk_in);
            cpl_pending_dmard = 1'b1;
            repeat(2) @(posedge clk_in);

            #1;


            check_outputs(7'h00, 1'b1, 128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transaction Acknowledgment behavior", test_num);
            reset_dut();
            @(posedge clk_in);
            cpl_pending_dmawr = 1'b1;
            repeat(5) @(posedge clk_in);
            tx_ack0 = 1'b1;
            tx_desc0 = 128'hA5A5A5A5_5A5A5A5A_12345678_87654321;
            @(posedge clk_in);
            tx_ack0 = 1'b0;
            repeat(2) @(posedge clk_in);

            #1;


            check_outputs(7'h00, 1'b1, 128'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clearing pending signals resets monitor", test_num);
            reset_dut();
            @(posedge clk_in);
            cpl_pending_dmard = 1'b1;
            repeat(10) @(posedge clk_in);
            cpl_pending_dmard = 1'b0;
            repeat(2) @(posedge clk_in);

            #1;


            check_outputs(7'h00, 1'b0, 128'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify err_desc remains zero by default", test_num);
            reset_dut();
            tx_desc0 = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            cpl_pending_dmawr = 1'b1;
            repeat(5) @(posedge clk_in);

            #1;


            check_outputs(7'h00, 1'b1, 128'h0);
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
        input [6:0] expected_cpl_err;
        input expected_cpl_pending;
        input [127:0] expected_err_desc;
        begin
            if (expected_cpl_err === (expected_cpl_err ^ cpl_err ^ expected_cpl_err) &&
                expected_cpl_pending === (expected_cpl_pending ^ cpl_pending ^ expected_cpl_pending) &&
                expected_err_desc === (expected_err_desc ^ err_desc ^ expected_err_desc)) begin
                $display("PASS");
                $display("  Outputs: cpl_err=%h, cpl_pending=%b, err_desc=%h",
                         cpl_err, cpl_pending, err_desc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpl_err=%h, cpl_pending=%b, err_desc=%h",
                         expected_cpl_err, expected_cpl_pending, expected_err_desc);
                $display("  Got:      cpl_err=%h, cpl_pending=%b, err_desc=%h",
                         cpl_err, cpl_pending, err_desc);
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
        $dumpvars(0,clk_in, cpl_pending_dmard, cpl_pending_dmawr, rstn, tx_ack0, tx_desc0, cpl_err, cpl_pending, err_desc);
    end

endmodule
