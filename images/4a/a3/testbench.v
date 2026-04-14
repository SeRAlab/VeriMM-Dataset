`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I1;
    reg [8:0] I2;
    reg [8:0] O2;
    reg Q;
    reg [255:0] din;
    reg rd_clk;
    reg tmp_ram_rd_en;
    reg wr_clk;
    wire [255:0] DOUTB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .I2(I2),
        .O2(O2),
        .Q(Q),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .wr_clk(wr_clk),
        .DOUTB(DOUTB)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            Q = 1;
            I1 = 0;
            tmp_ram_rd_en = 0;
            I2 = 0;
            O2 = 0;
            din = 0;
            repeat(10) @(posedge wr_clk);
            Q = 0;
            repeat(5) @(posedge wr_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single Word Write/Read...");
            reset_dut();


            @(posedge wr_clk);
            I1 = 1;
            din = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5_A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            @(posedge wr_clk);
            I1 = 0;


            repeat(5) @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;


            repeat(1) @(posedge rd_clk);
            #1;

            check_outputs(256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5_A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Consecutive Write/Read...");
            reset_dut();


            @(posedge wr_clk);
            I1 = 1; din = 256'h1; @(posedge wr_clk);
            I1 = 1; din = 256'h2; @(posedge wr_clk);
            I1 = 1; din = 256'h3; @(posedge wr_clk);
            I1 = 0;


            repeat(5) @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            @(posedge rd_clk);
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            repeat(1) @(posedge rd_clk);
            #1;

            check_outputs(256'h3);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Full FIFO Depth Test...");
            reset_dut();


            @(posedge wr_clk);
            I1 = 1;
            for (i = 0; i < 256; i = i + 1) begin
                din = i;
                @(posedge wr_clk);
            end
            I1 = 0;


            repeat(10) @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge rd_clk);
            end
            tmp_ram_rd_en = 0;

            repeat(1) @(posedge rd_clk);
            #1;

            check_outputs(255);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Interleaved Read/Write...");
            reset_dut();


            I1 = 1;
            for (i = 10; i < 15; i = i + 1) begin
                din = i;
                @(posedge wr_clk);
            end
            I1 = 0;


            fork
                begin
                    @(posedge wr_clk);
                    I1 = 1;
                    din = 256'hDEADBEEF;
                    @(posedge wr_clk);
                    I1 = 0;
                end
                begin
                    repeat(2) @(posedge rd_clk);
                    tmp_ram_rd_en = 1;
                    repeat(6) @(posedge rd_clk);
                    tmp_ram_rd_en = 0;
                end
            join

            repeat(1) @(posedge rd_clk);
            #1;

            check_outputs(256'hDEADBEEF);
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
        input [255:0] expected_DOUTB;
        begin
            if (expected_DOUTB === (expected_DOUTB ^ DOUTB ^ expected_DOUTB)) begin
                $display("PASS");
                $display("  Outputs: DOUTB=%h",
                         DOUTB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUTB=%h",
                         expected_DOUTB);
                $display("  Got:      DOUTB=%h",
                         DOUTB);
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
        $dumpvars(0,I1, I2, O2, Q, din, rd_clk, tmp_ram_rd_en, wr_clk, DOUTB);
    end

endmodule
