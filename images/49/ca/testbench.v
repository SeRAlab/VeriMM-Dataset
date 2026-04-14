`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg [4:0] waddr;
    reg wr;
    wire [31:0] dout1;
    wire [31:0] dout2;
    wire [31:0] ram1;
    wire [31:0] ram2;
    wire [31:0] ram3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wr(wr),
        .dout1(dout1),
        .dout2(dout2),
        .ram1(ram1),
        .ram2(ram2),
        .ram3(ram3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            waddr = 0;
            din = 0;
            raddr1 = 0;
            raddr2 = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Dedicated RAM outputs...");
            reset_dut();


            @(posedge clk); #1;
            wr = 1; waddr = 5'd1; din = 32'hAAAA_AAAA;
            @(posedge clk); #1;


            wr = 1; waddr = 5'd2; din = 32'hBBBB_BBBB;
            @(posedge clk); #1;


            wr = 1; waddr = 5'd3; din = 32'hCCCC_CCCC;
            @(posedge clk); #1;

            wr = 0;
            raddr1 = 5'd1;
            raddr2 = 5'd2;
            #2;

            #1;


            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Register 0 Hardwired Zero...");
            reset_dut();


            @(posedge clk); #1;
            wr = 1; waddr = 5'd0; din = 32'hFFFF_FFFF;
            @(posedge clk); #1;


            wr = 1; waddr = 5'd1; din = 32'h1111_1111;
            @(posedge clk); #1;

            wr = 0;
            raddr1 = 5'd0;
            raddr2 = 5'd1;
            #2;




            #1;





            check_outputs(32'h0, 32'h1111_1111, 32'h1111_1111, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Boundary Register (31) Access...");
            reset_dut();


            @(posedge clk); #1;
            wr = 1; waddr = 5'd31; din = 32'hDEAD_BEEF;
            @(posedge clk); #1;

            wr = 0;
            raddr1 = 5'd31;
            raddr2 = 5'd0;
            #2;

            #1;


            check_outputs(32'hDEAD_BEEF, 32'h0, 32'h1111_1111, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Simultaneous Dual Port Read...");
            reset_dut();


            @(posedge clk); #1;
            wr = 1; waddr = 5'd10; din = 32'h1010_1010;
            @(posedge clk); #1;
            wr = 1; waddr = 5'd20; din = 32'h2020_2020;
            @(posedge clk); #1;

            wr = 0;
            raddr1 = 5'd10;
            raddr2 = 5'd20;
            #2;

            #1;


            check_outputs(32'h1010_1010, 32'h2020_2020, 32'h1111_1111, 32'hBBBB_BBBB, 32'hCCCC_CCCC);
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
        input [31:0] expected_dout1;
        input [31:0] expected_dout2;
        input [31:0] expected_ram1;
        input [31:0] expected_ram2;
        input [31:0] expected_ram3;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2) &&
                expected_ram1 === (expected_ram1 ^ ram1 ^ expected_ram1) &&
                expected_ram2 === (expected_ram2 ^ ram2 ^ expected_ram2) &&
                expected_ram3 === (expected_ram3 ^ ram3 ^ expected_ram3)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h, ram1=%h, ram2=%h, ram3=%h",
                         dout1, dout2, ram1, ram2, ram3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h, ram1=%h, ram2=%h, ram3=%h",
                         expected_dout1, expected_dout2, expected_ram1, expected_ram2, expected_ram3);
                $display("  Got:      dout1=%h, dout2=%h, ram1=%h, ram2=%h, ram3=%h",
                         dout1, dout2, ram1, ram2, ram3);
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
        $dumpvars(0,clk, din, raddr1, raddr2, waddr, wr, dout1, dout2, ram1, ram2, ram3);
    end

endmodule
