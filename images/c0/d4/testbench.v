`timescale 1ns/1ps

module seg7led_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd;
    reg [2:0] rd_addr;
    reg rst;
    reg wr;
    reg [2:0] wr_addr;
    wire [7:0] dout;
    wire [7:0] seg7_data;
    wire [7:0] seg7_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    seg7led_interface dut (
        .clk(clk),
        .din(din),
        .rd(rd),
        .rd_addr(rd_addr),
        .rst(rst),
        .wr(wr),
        .wr_addr(wr_addr),
        .dout(dout),
        .seg7_data(seg7_data),
        .seg7_sel(seg7_sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("seg7led_interface Testbench");
        $display("========================================");


        
        
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
        input [7:0] expected_dout;
        input [7:0] expected_seg7_data;
        input [7:0] expected_seg7_sel;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_seg7_data === (expected_seg7_data ^ seg7_data ^ expected_seg7_data) &&
                expected_seg7_sel === (expected_seg7_sel ^ seg7_sel ^ expected_seg7_sel)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, seg7_data=%h, seg7_sel=%h",
                         dout, seg7_data, seg7_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, seg7_data=%h, seg7_sel=%h",
                         expected_dout, expected_seg7_data, expected_seg7_sel);
                $display("  Got:      dout=%h, seg7_data=%h, seg7_sel=%h",
                         dout, seg7_data, seg7_sel);
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
        $dumpvars(0,clk, din, rd, rd_addr, rst, wr, wr_addr, dout, seg7_data, seg7_sel);
    end

endmodule
