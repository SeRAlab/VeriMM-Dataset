`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] raddr;
    reg [7:0] waddr;
    reg [7:0] wdata;
    reg we;
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
        .we(we),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
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
            $display("Testcase 001: Simple Write and Read");
            reset_dut();


            we = 1;
            waddr = 8'h10;
            wdata = 8'h55;
            @(posedge clk);
            #1;
            we = 0;


            raddr = 8'h10;
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Overwrite existing data");
            reset_dut();


            we = 1;
            waddr = 8'h20;
            wdata = 8'hAA;
            @(posedge clk);
            #1;


            wdata = 8'hBB;
            @(posedge clk);
            #1;
            we = 0;

            raddr = 8'h20;
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Verify Write Enable (WE) logic");
            reset_dut();


            we = 1;
            waddr = 8'h30;
            wdata = 8'hCC;
            @(posedge clk);
            #1;


            we = 0;
            wdata = 8'hDD;
            @(posedge clk);
            #1;

            raddr = 8'h30;
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Multi-address storage check");
            reset_dut();


            we = 1;
            waddr = 8'h01;
            wdata = 8'h11;
            @(posedge clk);
            #1;


            waddr = 8'h02;
            wdata = 8'h22;
            @(posedge clk);
            #1;
            we = 0;


            raddr = 8'h01;
            #1;
            if (rdata !== 8'h11) begin
                #1;

                check_outputs(8'h11);
            end else begin

                raddr = 8'h02;
                #1;
                #1;

                check_outputs(8'h22);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Simultaneous Read and Write");
            reset_dut();


            we = 1;
            waddr = 8'h40;
            wdata = 8'hEE;
            @(posedge clk);
            #1;


            raddr = 8'h40;
            waddr = 8'h50;
            wdata = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE);
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
        $dumpvars(0,clk, raddr, waddr, wdata, we, rdata);
    end

endmodule
