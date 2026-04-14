`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] din;
    reg en;
    reg wr;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .en(en),
        .wr(wr),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            wr = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h010; din = 8'h55;
            @(posedge clk);


            wr = 0; addr = 10'h010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable (en) Signal Check", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h020; din = 8'hAA;
            @(posedge clk);


            en = 0; wr = 1; addr = 10'h020; din = 8'hFF;
            @(posedge clk);


            en = 1; wr = 0; addr = 10'h020;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'd0; din = 8'h01;
            @(posedge clk);


            addr = 10'd1023; din = 8'hFE;
            @(posedge clk);


            wr = 0; addr = 10'd1023;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Memory Isolation Check", test_num);
            reset_dut();


            @(posedge clk);
            en = 1; wr = 1; addr = 10'h0A; din = 8'h11;
            @(posedge clk);

            addr = 10'h0B; din = 8'h22;
            @(posedge clk);


            wr = 0; addr = 10'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();

            @(posedge clk);
            en = 1; wr = 1; addr = 10'h100; din = 8'hCC;
            @(posedge clk);
            din = 8'hDD;
            @(posedge clk);

            wr = 0;
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
        input [7:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, en, wr, dout);
    end

endmodule
