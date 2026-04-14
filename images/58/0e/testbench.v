`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Ix;
    reg [3:0] Qx;
    reg RESETn;
    reg [12:0] Wj_in;
    reg [12:0] Wr_in;
    reg clk;
    reg freeze_iqcomp;
    reg [1:0] op_mode;
    wire [3:0] Iy;
    wire [3:0] Qy;
    wire [12:0] Wj;
    wire [12:0] Wr;
    wire settled;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ix(Ix),
        .Qx(Qx),
        .RESETn(RESETn),
        .Wj_in(Wj_in),
        .Wr_in(Wr_in),
        .clk(clk),
        .freeze_iqcomp(freeze_iqcomp),
        .op_mode(op_mode),
        .Iy(Iy),
        .Qy(Qy),
        .Wj(Wj),
        .Wr(Wr),
        .settled(settled)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RESETn = 0;
            Ix = 0;
            Qx = 0;
            Wr_in = 0;
            Wj_in = 0;
            freeze_iqcomp = 0;
            op_mode = 0;
            repeat (2) @(posedge clk);
            #1 RESETn = 1;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Behavior");
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 13'h0000, 13'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Mode 0 Weight Update");
            reset_dut();
            op_mode = 2'b00;
            Wr_in = 13'sd1000;
            Wj_in = -13'sd500;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(Iy, Qy, -13'sd500, 13'sd1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Mode 1 Processing");
            reset_dut();
            op_mode = 2'b01;
            Wr_in = 13'sd2048;
            Wj_in = 13'sd0;
            Ix = 4'sd3;
            Qx = 4'sd2;
            repeat (10) @(posedge clk);


            if (settled === 1'b1)
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;
            $display("  Settled: %b", settled);
        end
        endtask

    task testcase004;

        reg [12:0] saved_wr;
        reg [12:0] saved_wj;
        begin
            $display("\nTestcase 004: Freeze Functionality");
            reset_dut();
            op_mode = 2'b00;
            Wr_in = 13'sd123;
            Wj_in = 13'sd456;
            repeat (2) @(posedge clk);
            freeze_iqcomp = 1;
            #1;
            saved_wr = Wr;
            saved_wj = Wj;


            Wr_in = 13'sd999;
            Wj_in = 13'sd999;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(Iy, Qy, saved_wj, saved_wr, settled);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Large Negative Values");
            reset_dut();
            op_mode = 2'b00;
            Wr_in = -13'sd4096;
            Wj_in = -13'sd4096;
            Ix = -4'sd8;
            Qx = -4'sd8;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(Iy, Qy, -13'sd4096, -13'sd4096, 1'b1);
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
        input [3:0] expected_Iy;
        input [3:0] expected_Qy;
        input [12:0] expected_Wj;
        input [12:0] expected_Wr;
        input expected_settled;
        begin
            if (expected_Iy === (expected_Iy ^ Iy ^ expected_Iy) &&
                expected_Qy === (expected_Qy ^ Qy ^ expected_Qy) &&
                expected_Wj === (expected_Wj ^ Wj ^ expected_Wj) &&
                expected_Wr === (expected_Wr ^ Wr ^ expected_Wr) &&
                expected_settled === (expected_settled ^ settled ^ expected_settled)) begin
                $display("PASS");
                $display("  Outputs: Iy=%h, Qy=%h, Wj=%h, Wr=%h, settled=%b",
                         Iy, Qy, Wj, Wr, settled);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Iy=%h, Qy=%h, Wj=%h, Wr=%h, settled=%b",
                         expected_Iy, expected_Qy, expected_Wj, expected_Wr, expected_settled);
                $display("  Got:      Iy=%h, Qy=%h, Wj=%h, Wr=%h, settled=%b",
                         Iy, Qy, Wj, Wr, settled);
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
        $dumpvars(0,Ix, Qx, RESETn, Wj_in, Wr_in, clk, freeze_iqcomp, op_mode, Iy, Qy, Wj, Wr, settled);
    end

endmodule
