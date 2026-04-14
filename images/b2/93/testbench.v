`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [31:0] wrdata;
    reg wrenb;
    wire [31:0] rddata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .wrdata(wrdata),
        .wrenb(wrenb),
        .rddata(rddata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            wrenb = 0;
            wrdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();


            addr = 4'h0;
            wrdata = 32'hABCDEF01;
            wrenb = 1;
            @(posedge clk);
            #1;


            wrenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read Address 15", test_num);
            reset_dut();


            addr = 4'hF;
            wrdata = 32'h12345678;
            wrenb = 1;
            @(posedge clk);
            #1;


            wrenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify wrenb=0 inhibits writing", test_num);
            reset_dut();


            addr = 4'h5;
            wrdata = 32'h55555555;
            wrenb = 1;
            @(posedge clk);
            #1;


            wrdata = 32'hAAAAAAAA;
            wrenb = 0;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite value", test_num);
            reset_dut();


            addr = 4'h7;
            wrdata = 32'h11111111;
            wrenb = 1;
            @(posedge clk);
            #1;


            wrdata = 32'h22222222;
            @(posedge clk);
            #1;


            wrenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential address check", test_num);
            reset_dut();


            addr = 4'h1;
            wrdata = 32'h00000001;
            wrenb = 1;
            @(posedge clk);
            #1;


            addr = 4'h2;
            wrdata = 32'h00000002;
            @(posedge clk);
            #1;


            addr = 4'h1;
            wrenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High/Low bit pattern", test_num);
            reset_dut();

            addr = 4'hC;
            wrdata = 32'hF0F0F0F0;
            wrenb = 1;
            @(posedge clk);
            #1;

            wrenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hF0F0F0F0);
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
        input [31:0] expected_rddata;
        begin
            if (expected_rddata === (expected_rddata ^ rddata ^ expected_rddata)) begin
                $display("PASS");
                $display("  Outputs: rddata=%h",
                         rddata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rddata=%h",
                         expected_rddata);
                $display("  Got:      rddata=%h",
                         rddata);
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
        $dumpvars(0,addr, clk, wrdata, wrenb, rddata);
    end

endmodule
