`timescale 1ns/1ps

module IFFT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] xi0;
    reg [7:0] xi1;
    reg [7:0] xi2;
    reg [7:0] xi3;
    reg [7:0] xr0;
    reg [7:0] xr1;
    reg [7:0] xr2;
    reg [7:0] xr3;
    wire [7:0] yi0;
    wire [7:0] yi1;
    wire [7:0] yi2;
    wire [7:0] yi3;
    wire [7:0] yr0;
    wire [7:0] yr1;
    wire [7:0] yr2;
    wire [7:0] yr3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT dut (
        .clk(clk),
        .rst(rst),
        .xi0(xi0),
        .xi1(xi1),
        .xi2(xi2),
        .xi3(xi3),
        .xr0(xr0),
        .xr1(xr1),
        .xr2(xr2),
        .xr3(xr3),
        .yi0(yi0),
        .yi1(yi1),
        .yi2(yi2),
        .yi3(yi3),
        .yr0(yr0),
        .yr1(yr1),
        .yr2(yr2),
        .yr3(yr3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            xi0 = 0; xi1 = 0; xi2 = 0; xi3 = 0;
            xr0 = 0; xr1 = 0; xr2 = 0; xr3 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            reset_dut();
            xr0 = 8'h00; xr1 = 8'h00; xr2 = 8'h00; xr3 = 8'h00;
            xi0 = 8'h00; xi1 = 8'h00; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: DC Component (Real)");
            reset_dut();
            xr0 = 8'h04; xr1 = 8'h00; xr2 = 8'h00; xr3 = 8'h00;
            xi0 = 8'h00; xi1 = 8'h00; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h01, 8'h01, 8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Constant Frequency Input");
            reset_dut();
            xr0 = 8'h04; xr1 = 8'h04; xr2 = 8'h04; xr3 = 8'h04;
            xi0 = 8'h00; xi1 = 8'h00; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pure Imaginary Input");
            reset_dut();
            xr0 = 8'h00; xr1 = 8'h00; xr2 = 8'h00; xr3 = 8'h00;
            xi0 = 8'h00; xi1 = 8'h04; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h01, 8'h00, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'h00, 8'h01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed Real with Negative Values");
            reset_dut();
            xr0 = 8'h08; xr1 = 8'h00; xr2 = 8'hF8; xr3 = 8'h00;
            xi0 = 8'h00; xi1 = 8'h00; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h04);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High Frequency Input");
            reset_dut();
            xr0 = 8'h00; xr1 = 8'h00; xr2 = 8'h04; xr3 = 8'h00;
            xi0 = 8'h00; xi1 = 8'h00; xi2 = 8'h00; xi3 = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h01, 8'hFF, 8'h01, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT Testbench");
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
        input [7:0] expected_yi0;
        input [7:0] expected_yi1;
        input [7:0] expected_yi2;
        input [7:0] expected_yi3;
        input [7:0] expected_yr0;
        input [7:0] expected_yr1;
        input [7:0] expected_yr2;
        input [7:0] expected_yr3;
        begin
            if (expected_yi0 === (expected_yi0 ^ yi0 ^ expected_yi0) &&
                expected_yi1 === (expected_yi1 ^ yi1 ^ expected_yi1) &&
                expected_yi2 === (expected_yi2 ^ yi2 ^ expected_yi2) &&
                expected_yi3 === (expected_yi3 ^ yi3 ^ expected_yi3) &&
                expected_yr0 === (expected_yr0 ^ yr0 ^ expected_yr0) &&
                expected_yr1 === (expected_yr1 ^ yr1 ^ expected_yr1) &&
                expected_yr2 === (expected_yr2 ^ yr2 ^ expected_yr2) &&
                expected_yr3 === (expected_yr3 ^ yr3 ^ expected_yr3)) begin
                $display("PASS");
                $display("  Outputs: yi0=%h, yi1=%h, yi2=%h, yi3=%h, yr0=%h, yr1=%h, yr2=%h, yr3=%h",
                         yi0, yi1, yi2, yi3, yr0, yr1, yr2, yr3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yi0=%h, yi1=%h, yi2=%h, yi3=%h, yr0=%h, yr1=%h, yr2=%h, yr3=%h",
                         expected_yi0, expected_yi1, expected_yi2, expected_yi3, expected_yr0, expected_yr1, expected_yr2, expected_yr3);
                $display("  Got:      yi0=%h, yi1=%h, yi2=%h, yi3=%h, yr0=%h, yr1=%h, yr2=%h, yr3=%h",
                         yi0, yi1, yi2, yi3, yr0, yr1, yr2, yr3);
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
        $dumpvars(0,clk, rst, xi0, xi1, xi2, xi3, xr0, xr1, xr2, xr3, yi0, yi1, yi2, yi3, yr0, yr1, yr2, yr3);
    end

endmodule
