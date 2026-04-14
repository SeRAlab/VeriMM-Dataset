`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] Q;
    reg WEA;
    reg clk;
    reg [63:0] din;
    reg srst;
    reg tmp_ram_rd_en;
    wire [63:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .WEA(WEA),
        .clk(clk),
        .din(din),
        .srst(srst),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            srst = 1;
            WEA = 0;
            tmp_ram_rd_en = 0;
            din = 0;
            Q = 0;
            @(posedge clk);
            #1 srst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Single Write/Read");
            reset_dut();


            WEA = 1;
            din = 64'hFEED_FACE_CAFE_BEEF;
            @(posedge clk);
            #1 WEA = 0;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1 tmp_ram_rd_en = 0;


            #1 #1;
 check_outputs(64'hFEED_FACE_CAFE_BEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Burst Write/Read (3 entries)");
            reset_dut();


            WEA = 1;
            din = 64'h1; @(posedge clk);
            din = 64'h2; @(posedge clk);
            din = 64'h3; @(posedge clk);
            #1 WEA = 0;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 tmp_ram_rd_en = 0;


            #1 #1;
 check_outputs(64'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Full Capacity (16 entries)");
            reset_dut();


            WEA = 1;
            for (i = 1; i <= 16; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            #1 WEA = 0;


            tmp_ram_rd_en = 1;
            for (i = 1; i <= 16; i = i + 1) begin
                @(posedge clk);
            end
            #1 tmp_ram_rd_en = 0;


            #1 #1;
 check_outputs(64'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Interleaved R/W");
            reset_dut();


            WEA = 1;
            din = 64'hAAAA; @(posedge clk);
            din = 64'hBBBB; @(posedge clk);
            WEA = 0;


            tmp_ram_rd_en = 1; @(posedge clk);
            tmp_ram_rd_en = 0;


            WEA = 1;
            din = 64'hCCCC; @(posedge clk);
            WEA = 0;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            @(posedge clk);
            #1 tmp_ram_rd_en = 0;

            #1 #1;
 check_outputs(64'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Mid-operation Reset");
            reset_dut();


            WEA = 1;
            din = 64'hFFFF; @(posedge clk);
            WEA = 0;


            reset_dut();


            WEA = 1;
            din = 64'h1234; @(posedge clk);
            WEA = 0;


            tmp_ram_rd_en = 1; @(posedge clk);
            #1 tmp_ram_rd_en = 0;

            #1 #1;
 check_outputs(64'h1234);
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
        input [63:0] expected_dout;
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
        $dumpvars(0,Q, WEA, clk, din, srst, tmp_ram_rd_en, dout);
    end

endmodule
