`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dbgsel;
    reg [7:0] dval0;
    reg rstn;
    wire [7:0] dout0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dbgsel(dbgsel),
        .dval0(dval0),
        .rstn(rstn),
        .dout0(dout0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            dbgsel = 0;
            dval0 = 0;
            @(posedge clk);
            #2;
            rstn = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            dbgsel = 8'd20;
            dval0 = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dbgsel = 8'd34;
            dval0 = 8'hA5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            dbgsel = 8'd50;
            dval0 = 8'h5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            dbgsel = 8'd64;
            dval0 = 8'h12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            dbgsel = 8'd65;
            dval0 = 8'hCC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            dbgsel = 8'd50;
            dval0 = 8'hEE;
            @(posedge clk);
            #2;

            if (dout0 !== 8'hEE) begin
                $display("Pre-reset check failed");
            end

            rstn = 0;
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_dout0;
        begin
            if (expected_dout0 === (expected_dout0 ^ dout0 ^ expected_dout0)) begin
                $display("PASS");
                $display("  Outputs: dout0=%h",
                         dout0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout0=%h",
                         expected_dout0);
                $display("  Got:      dout0=%h",
                         dout0);
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
        $dumpvars(0,clk, dbgsel, dval0, rstn, dout0);
    end

endmodule
