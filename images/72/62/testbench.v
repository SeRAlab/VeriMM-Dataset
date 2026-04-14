`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [31:0] din;
    reg rst;
    reg we;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .rst(rst),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset behavior", test_num);
            reset_dut();


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Write and Read", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            addr = 16'h1234;
            din = 32'hDEADBEEF;

            @(posedge clk);
            we = 0;
            addr = 16'h1234;

            @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Address Persistence", test_num);
            reset_dut();


            @(posedge clk);
            we = 1; addr = 16'hAAAA; din = 32'hA1A1A1A1;

            @(posedge clk);
            we = 1; addr = 16'hBBBB; din = 32'hB2B2B2B2;


            @(posedge clk);
            we = 0; addr = 16'hAAAA;
            @(posedge clk);


            we = 0; addr = 16'hBBBB;
            @(posedge clk);

            #1;


            check_outputs(32'hB2B2B2B2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Overwrite", test_num);
            reset_dut();

            @(posedge clk);
            we = 1; addr = 16'h00FF; din = 32'h00001111;
            @(posedge clk);
            we = 1; addr = 16'h00FF; din = 32'hFFFFEEEE;
            @(posedge clk);
            we = 0; addr = 16'h00FF;
            @(posedge clk);
            #1;

            check_outputs(32'hFFFFEEEE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Address (0xFFFF)", test_num);
            reset_dut();

            @(posedge clk);
            we = 1; addr = 16'hFFFF; din = 32'h55AA55AA;
            @(posedge clk);
            we = 0; addr = 16'hFFFF;
            @(posedge clk);
            #1;

            check_outputs(32'h55AA55AA);
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, rst, we, dout);
    end

endmodule
