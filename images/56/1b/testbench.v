`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr;
    reg clk;
    reg [31:0] din;
    reg en;
    reg [3:0] wen;
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
        .en(en),
        .wen(wen),
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
            wen = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            wen = 4'hF;
            addr = 14'h0010;
            din = 32'h12345678;

            @(negedge clk);
            wen = 4'h0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Byte-wise Write Enable", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            wen = 4'hF;
            addr = 14'h0020;
            din = 32'hFFFFFFFF;



            @(negedge clk);
            wen = 4'b0101;
            din = 32'h00AA00BB;

            @(negedge clk);
            wen = 4'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFAAFFBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Check", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            wen = 4'hF;
            addr = 14'h0030;
            din = 32'h5555AAAA;


            @(negedge clk);
            en = 0;
            wen = 4'hF;
            din = 32'h00000000;


            @(negedge clk);
            en = 1;
            wen = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Address Boundary", test_num);
            reset_dut();


            @(negedge clk);
            en = 1;
            wen = 4'hF;
            addr = 14'h3FFF;
            din = 32'hC0DEBABE;

            @(negedge clk);
            wen = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0DEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Operations", test_num);
            reset_dut();


            @(negedge clk);
            en = 1; wen = 4'hF; addr = 14'h00A0; din = 32'h11111111;

            @(negedge clk);
            addr = 14'h00B0; din = 32'h22222222;


            @(negedge clk);
            wen = 0; addr = 14'h00A0;
            @(posedge clk);
            #2;


            @(negedge clk);
            addr = 14'h00B0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h22222222);
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
        $dumpvars(0,addr, clk, din, en, wen, dout);
    end

endmodule
