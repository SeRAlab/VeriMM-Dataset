`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [93:0] din;
    reg rd_en;
    reg wr_en;
    wire [93:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd_en = 0;
            wr_en = 0;
            din = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running testcase001: Single Write/Read...");


            @(posedge clk);
            wr_en = 1;
            din = 94'h123456789ABCDEF012345678;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(94'h123456789ABCDEF012345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running testcase002: Multiple Burst Writes...");


            @(posedge clk);
            wr_en = 1; din = 94'hA;
            @(posedge clk);
            wr_en = 1; din = 94'hB;
            @(posedge clk);
            wr_en = 1; din = 94'hC;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            rd_en = 0;

            #1;

            #1;


            check_outputs(94'hC);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            $display("Running testcase003: Full Depth (64 entries)...");


            for (i = 1; i <= 64; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                din = i;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 1; i <= 64; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(94'd64);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            $display("Running testcase004: Pointer Wrap-around...");


            for (i = 1; i <= 40; i = i + 1) begin
                @(posedge clk);
                wr_en = 1; din = i;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 1; i <= 40; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;


            for (i = 1; i <= 30; i = i + 1) begin
                @(posedge clk);
                wr_en = 1; din = 94'hDEADBEEF + i;
            end
            @(posedge clk);
            wr_en = 0;


            for (i = 1; i <= 30; i = i + 1) begin
                @(posedge clk);
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(94'hDEADBEEF + 30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running testcase005: Simultaneous Read/Write...");


            @(posedge clk);
            wr_en = 1; din = 94'h111;
            @(posedge clk);


            wr_en = 1; din = 94'h222;
            rd_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(94'h222);
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
        input [93:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, rd_en, wr_en, dout);
    end

endmodule
