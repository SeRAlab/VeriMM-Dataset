`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena_;
    reg [7:0] fl_dout;
    reg [1:0] mode;
    reg [7:0] r0_dout;
    reg rst_;
    wire [7:0] fl_din;
    wire fl_we_;
    wire rdy_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena_(ena_),
        .fl_dout(fl_dout),
        .mode(mode),
        .r0_dout(r0_dout),
        .rst_(rst_),
        .fl_din(fl_din),
        .fl_we_(fl_we_),
        .rdy_(rdy_)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_ = 0;
            ena_ = 1;
            mode = 0;
            r0_dout = 8'h00;
            fl_dout = 8'h00;
            @(posedge clk);
            #1 rst_ = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rst_ = 0;
            #2;

            #1;


            check_outputs(8'hxx, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ena_ = 1;
            mode = 2'b00;
            r0_dout = 8'hAA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(fl_din, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            ena_ = 0;
            mode = 2'b00;
            r0_dout = 8'h55;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ena_ = 0;
            mode = 2'b01;
            r0_dout = 8'h0F;
            @(posedge clk);
            #2;


            #1;



            check_outputs(~8'h0F, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            ena_ = 0;
            mode = 2'b10;
            r0_dout = 8'hCC;
            fl_dout = 8'h33;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hCC ^ 8'h33, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            ena_ = 0;
            mode = 2'b11;
            r0_dout = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
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
        input [7:0] expected_fl_din;
        input expected_fl_we_;
        input expected_rdy_;
        begin
            if (expected_fl_din === (expected_fl_din ^ fl_din ^ expected_fl_din) &&
                expected_fl_we_ === (expected_fl_we_ ^ fl_we_ ^ expected_fl_we_) &&
                expected_rdy_ === (expected_rdy_ ^ rdy_ ^ expected_rdy_)) begin
                $display("PASS");
                $display("  Outputs: fl_din=%h, fl_we_=%b, rdy_=%b",
                         fl_din, fl_we_, rdy_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fl_din=%h, fl_we_=%b, rdy_=%b",
                         expected_fl_din, expected_fl_we_, expected_rdy_);
                $display("  Got:      fl_din=%h, fl_we_=%b, rdy_=%b",
                         fl_din, fl_we_, rdy_);
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
        $dumpvars(0,clk, ena_, fl_dout, mode, r0_dout, rst_, fl_din, fl_we_, rdy_);
    end

endmodule
