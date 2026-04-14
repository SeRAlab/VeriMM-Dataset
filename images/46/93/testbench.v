`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg [1:0] bank_sel;
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
        .bank_sel(bank_sel),
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
            rst = 1;
            we = 0;
            addr = 0;
            din = 0;
            bank_sel = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Write/Read Bank 0", test_num);
            reset_dut();
            @(posedge clk);
            we = 1; addr = 32'h0000_0001; din = 32'hCAFE_BABE; bank_sel = 2'b00;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Write/Read Bank 3", test_num);
            reset_dut();
            @(posedge clk);
            we = 1; addr = 32'h0000_000F; din = 32'h1234_5678; bank_sel = 2'b11;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Bank Isolation", test_num);
            reset_dut();
            @(posedge clk);
            we = 1; addr = 32'h0000_00AA; din = 32'hAAAA_AAAA; bank_sel = 2'b01;
            @(posedge clk);
            we = 1; addr = 32'h0000_00AA; din = 32'hBBBB_BBBB; bank_sel = 2'b10;
            @(posedge clk);
            we = 0; bank_sel = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Write Enable (WE) Inactive", test_num);
            reset_dut();

            @(posedge clk);
            we = 1; addr = 32'h55; din = 32'hD00D_FEED; bank_sel = 2'b00;
            @(posedge clk);

            we = 0; addr = 32'h55; din = 32'hDEAD_BEEF;
            @(posedge clk);

            @(posedge clk);
            #1 #1;
 check_outputs(32'hD00D_FEED);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Overwrite Data", test_num);
            reset_dut();
            @(posedge clk);
            we = 1; addr = 32'h100; din = 32'h1111_1111; bank_sel = 2'b00;
            @(posedge clk);
            we = 1; addr = 32'h100; din = 32'h2222_2222; bank_sel = 2'b00;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: High Address Boundary", test_num);
            reset_dut();
            @(posedge clk);
            we = 1; addr = 32'hFFFF_FFFC; din = 32'hA5A5_5A5A; bank_sel = 2'b01;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hA5A5_5A5A);
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
        $dumpvars(0,addr, bank_sel, clk, din, rst, we, dout);
    end

endmodule
