`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] idata;
    reg re;
    reg rst;
    reg we;
    wire full;
    wire oready;
    wire [7:0] wdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .idata(idata),
        .re(re),
        .rst(rst),
        .we(we),
        .full(full),
        .oready(oready),
        .wdata(wdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        we = 0;
        re = 0;
        idata = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial State after Reset", test_num);
        reset_dut();
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Propagation to Oready (10 stages)", test_num);
        reset_dut();


        we = 1; idata = 8'hAA; @(posedge clk);
        we = 0; idata = 0;




        repeat(9) @(posedge clk);

        #1;

        #1;


        check_outputs(1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Filling to Full Capacity", test_num);
        reset_dut();

        we = 1;

        repeat(10) begin
            idata = $random;
            @(posedge clk);
        end
        we = 0;

        #1;


        #1;



        check_outputs(1'b1, 1'b1, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Integrity and Read Operation", test_num);
        reset_dut();


        we = 1; idata = 8'h55; @(posedge clk);
        we = 0;


        repeat(9) @(posedge clk);


        re = 1; @(posedge clk);
        re = 0;

        #1;

        #1;


        check_outputs(1'b0, 1'b0, 8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-stage Sequence", test_num);
        reset_dut();


        we = 1; idata = 8'hFF; @(posedge clk);
        we = 0;


        repeat(5) @(posedge clk);


        if (oready === 0 && full === 0) begin

            repeat(4) @(posedge clk);
            re = 1; @(posedge clk);
            re = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 8'hFF);
        end else begin
            $display("FAIL: Premature ready signal");
            fail_count = fail_count + 1;
        end
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
        input expected_full;
        input expected_oready;
        input [7:0] expected_wdata;
        begin
            if (expected_full === (expected_full ^ full ^ expected_full) &&
                expected_oready === (expected_oready ^ oready ^ expected_oready) &&
                expected_wdata === (expected_wdata ^ wdata ^ expected_wdata)) begin
                $display("PASS");
                $display("  Outputs: full=%b, oready=%b, wdata=%h",
                         full, oready, wdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: full=%b, oready=%b, wdata=%h",
                         expected_full, expected_oready, expected_wdata);
                $display("  Got:      full=%b, oready=%b, wdata=%h",
                         full, oready, wdata);
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
        $dumpvars(0,clk, idata, re, rst, we, full, oready, wdata);
    end

endmodule
