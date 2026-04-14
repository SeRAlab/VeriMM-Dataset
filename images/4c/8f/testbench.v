`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr;
    reg [3:0] waddr;
    reg [7:0] wdata;
    reg wen;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            waddr = 0;
            wdata = 0;
            raddr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            waddr = 4'h0; wdata = 8'hA5; wen = 1;
            @(posedge clk);
            #1;
            wen = 0;
            raddr = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            waddr = 4'hF; wdata = 8'h5A; wen = 1;
            @(posedge clk);
            #1;
            wen = 0;
            raddr = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            waddr = 4'h5; wdata = 8'h11; wen = 1;
            @(posedge clk);
            #1;

            waddr = 4'h5; wdata = 8'hEE; wen = 0;
            @(posedge clk);
            #1;
            raddr = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            waddr = 4'h2; wdata = 8'h22; wen = 1;
            @(posedge clk);
            #1;

            waddr = 4'h3; wdata = 8'h33; wen = 1; raddr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            waddr = 4'h8; wdata = 8'hCC; wen = 1;
            @(posedge clk);
            #1;

            waddr = 4'h8; wdata = 8'hDD; wen = 1;
            @(posedge clk);
            #1;
            wen = 0;
            raddr = 4'h8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hDD);
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,clk, raddr, waddr, wdata, wen, rdata);
    end

endmodule
