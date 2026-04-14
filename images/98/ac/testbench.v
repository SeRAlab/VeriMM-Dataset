`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] rdsel1;
    reg [4:0] rdsel2;
    reg rst;
    reg wenable;
    reg [31:0] wtdata;
    reg [4:0] wtsel;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rdsel1(rdsel1),
        .rdsel2(rdsel2),
        .rst(rst),
        .wenable(wenable),
        .wtdata(wtdata),
        .wtsel(wtsel),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wenable = 0;
            rdsel1 = 0;
            rdsel2 = 0;
            wtsel = 0;
            wtdata = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            rdsel1 = 5;
            rdsel2 = 31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            @(negedge clk);
            wenable = 1; wtsel = 15; wtdata = 32'hDEADBEEF;
            @(negedge clk);
            wenable = 0;

            rdsel1 = 15; rdsel2 = 15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            @(negedge clk);
            wenable = 1; wtsel = 10; wtdata = 32'h12345678;
            @(negedge clk);

            wtsel = 20; wtdata = 32'hABCDEF00;
            @(negedge clk);
            wenable = 0;

            rdsel1 = 10; rdsel2 = 20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'hABCDEF00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            @(negedge clk);
            wenable = 0; wtsel = 7; wtdata = 32'hFFFFFFFF;
            @(negedge clk);
            rdsel1 = 7; rdsel2 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            @(negedge clk);
            wenable = 1; wtsel = 2; wtdata = 32'hAAAA_AAAA;
            @(negedge clk);

            wtdata = 32'hBBBB_BBBB;
            @(negedge clk);
            wenable = 0;
            rdsel1 = 2; rdsel2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            @(negedge clk);
            wenable = 1; wtsel = 0; wtdata = 32'h1111_2222;
            @(negedge clk);

            wtsel = 31; wtdata = 32'hCCCC_DDDD;
            @(negedge clk);
            wenable = 0;
            rdsel1 = 0; rdsel2 = 31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1111_2222, 32'hCCCC_DDDD);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, rdsel1, rdsel2, rst, wenable, wtdata, wtsel, rdata1, rdata2);
    end

endmodule
