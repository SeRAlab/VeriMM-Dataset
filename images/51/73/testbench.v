`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [143:0] port0_ci;
    reg [143:0] port1_ci;
    reg [143:0] port2_ci;
    reg [143:0] port3_ci;
    reg rst;
    reg sel0;
    reg sel1;
    wire [143:0] port_co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .port0_ci(port0_ci),
        .port1_ci(port1_ci),
        .port2_ci(port2_ci),
        .port3_ci(port3_ci),
        .rst(rst),
        .sel0(sel0),
        .sel1(sel1),
        .port_co(port_co)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        port0_ci = 144'h0;
        port1_ci = 144'h0;
        port2_ci = 144'h0;
        port3_ci = 144'h0;
        sel0 = 0;
        sel1 = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset check...");
        reset_dut();
        #1;

        check_outputs(144'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Select Port 0...");
        reset_dut();
        port0_ci = 144'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111_2222;
        sel1 = 0; sel0 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111_2222);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Select Port 1...");
        reset_dut();
        port1_ci = 144'h1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0_1234;
        sel1 = 0; sel0 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'h1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0_1234);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Select Port 2...");
        reset_dut();
        port2_ci = 144'hFEDC_BA98_7654_3210_FEDC_BA98_7654_3210_FEDC;
        sel1 = 1; sel0 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'hFEDC_BA98_7654_3210_FEDC_BA98_7654_3210_FEDC);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Select Port 3...");
        reset_dut();
        port3_ci = 144'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        sel1 = 1; sel0 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Synchronous Reset Priority Check...");
        reset_dut();

        port0_ci = 144'h5555_5555_5555_5555_5555_5555_5555_5555_5555;
        sel1 = 0; sel0 = 0;
        @(posedge clk);
        #1;

        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'h0);
        rst = 0;
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Switching ports sequentially...");
        reset_dut();
        port0_ci = 144'hA;
        port1_ci = 144'hB;


        sel1 = 0; sel0 = 0;
        @(posedge clk);
        #1;


        sel1 = 0; sel0 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(144'hB);
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
        input [143:0] expected_port_co;
        begin
            if (expected_port_co === (expected_port_co ^ port_co ^ expected_port_co)) begin
                $display("PASS");
                $display("  Outputs: port_co=%h",
                         port_co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_co=%h",
                         expected_port_co);
                $display("  Got:      port_co=%h",
                         port_co);
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
        $dumpvars(0,clk, port0_ci, port1_ci, port2_ci, port3_ci, rst, sel0, sel1, port_co);
    end

endmodule
