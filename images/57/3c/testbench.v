`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg en;
    reg rst;
    wire [31:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        data_in = 8'h0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        @(posedge clk);
        data_in = 8'h00;
        en = 1;
        @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'hD202EF8D);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        @(posedge clk);
        data_in = 8'h01;
        en = 1;
        @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'hA505DF1B);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        @(posedge clk);
        en = 1;
        data_in = 8'h31; @(posedge clk);
        data_in = 8'h32; @(posedge clk);
        data_in = 8'h33; @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'h884863D2);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        @(posedge clk);
        en = 1;
        data_in = 8'hDE; @(posedge clk);
        data_in = 8'hAD; @(posedge clk);
        data_in = 8'hBE; @(posedge clk);
        data_in = 8'hEF; @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'hFF22D926);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        @(posedge clk);
        en = 1;
        data_in = 8'h31;
        @(posedge clk);
        en = 0;
        data_in = 8'hFF;
        @(posedge clk);
        en = 1;
        data_in = 8'h32;
        @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'h3A6AD01A);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        @(posedge clk);
        en = 1;
        data_in = 8'hDE; @(posedge clk);
        data_in = 8'hAD; @(posedge clk);
        rst = 1;         @(posedge clk);
        rst = 0;
        data_in = 8'h01; @(posedge clk);
        en = 0;
        #1 #1;
 check_outputs(32'hA505DF1B);
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
        input [31:0] expected_crc;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
        $dumpvars(0,clk, data_in, en, rst, crc);
    end

endmodule
