`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WE;
    reg [7:0] addr;
    reg clk;
    reg [15:0] wdata;
    wire [15:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WE(WE),
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            WE = 0;
            addr = 0;
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            WE = 1;
            addr = 8'h00;
            wdata = 16'hABCD;

            @(posedge clk);

            WE = 0;
            addr = 8'h00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            WE = 1;
            addr = 8'hFF;
            wdata = 16'h55AA;

            @(posedge clk);

            WE = 0;
            addr = 8'hFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            WE = 1;
            addr = 8'h10;
            wdata = 16'h1111;


            @(posedge clk);
            WE = 1;
            addr = 8'h10;
            wdata = 16'h2222;

            @(posedge clk);

            WE = 0;
            addr = 8'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            WE = 1;
            addr = 8'h20;
            wdata = 16'hAAAA;


            @(posedge clk);
            WE = 0;
            addr = 8'h20;
            wdata = 16'h5555;

            @(posedge clk);

            WE = 0;
            addr = 8'h20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            WE = 1;
            addr = 8'h30;
            wdata = 16'hDEAD;


            @(posedge clk);
            WE = 1;
            addr = 8'h31;
            wdata = 16'hBEEF;

            @(posedge clk);

            WE = 0;
            addr = 8'h30;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 8'h40; wdata = 16'h0001;
            @(posedge clk);
            WE = 1; addr = 8'h41; wdata = 16'h0002;
            @(posedge clk);
            WE = 1; addr = 8'h42; wdata = 16'h0003;


            @(posedge clk);
            WE = 0;
            addr = 8'h42;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003);
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
        input [15:0] expected_rdata;
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
        $dumpvars(0,WE, addr, clk, wdata, rdata);
    end

endmodule
