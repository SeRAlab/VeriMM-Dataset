`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] data;
    reg we;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read at address 0");
            reset_dut();
            test_num = test_num + 1;


            we = 1;
            addr = 10'd0;
            data = 8'hA5;
            @(posedge clk);
            #1;


            we = 0;
            addr = 10'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write and Read at address 1023");
            reset_dut();
            test_num = test_num + 1;


            we = 1;
            addr = 10'd1023;
            data = 8'h5A;
            @(posedge clk);
            #1;


            we = 0;
            addr = 10'd1023;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwriting data");
            reset_dut();
            test_num = test_num + 1;


            we = 1;
            addr = 10'd512;
            data = 8'h11;
            @(posedge clk);
            #1;


            we = 1;
            addr = 10'd512;
            data = 8'h22;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Address independence");
            reset_dut();
            test_num = test_num + 1;


            we = 1; addr = 10'd10; data = 8'hAA;
            @(posedge clk); #1;


            we = 1; addr = 10'd20; data = 8'hBB;
            @(posedge clk); #1;


            we = 0; addr = 10'd10;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Verify we=0 inhibits writing");
            reset_dut();
            test_num = test_num + 1;


            we = 1; addr = 10'd100; data = 8'hCC;
            @(posedge clk); #1;


            we = 0; addr = 10'd100; data = 8'hFF;
            @(posedge clk); #1;


            we = 0; addr = 10'd100;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hCC);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,addr, clk, data, we, q);
    end

endmodule
