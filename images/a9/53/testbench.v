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
        I1 = 0;
        I2 = 0;
        O2 = 0;
        Q = 0;
        din = 0;
        tmp_ram_rd_en = 0;
        repeat(2) @(posedge wr_clk);
        repeat(2) @(posedge rd_clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Basic Write and Read at Addr 0");
        reset_dut();


        @(posedge wr_clk);
        I1 = 1;
        O2 = 9'd0;
        din = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        @(posedge wr_clk);
        I1 = 0;


        @(posedge rd_clk);
        tmp_ram_rd_en = 1;
        I2 = 9'd0;
        @(posedge rd_clk);
        #1;
        #1;

        check_outputs(256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Boundary Test at Addr 511");
        reset_dut();


        @(posedge wr_clk);
        I1 = 1;
        O2 = 9'd511;
        din = 256'h5555555555555555555555555555555555555555555555555555555555555555;
        @(posedge wr_clk);
        I1 = 0;


        @(posedge rd_clk);
        tmp_ram_rd_en = 1;
        I2 = 9'd511;
        @(posedge rd_clk);
        #1;
        #1;

        check_outputs(256'h5555555555555555555555555555555555555555555555555555555555555555);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Consecutive addresses check");
        reset_dut();


        @(posedge wr_clk);
        I1 = 1; O2 = 9'd10; din = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
        @(posedge wr_clk);

        O2 = 9'd11; din = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;
        @(posedge wr_clk);
        I1 = 0;


        @(posedge rd_clk);
        tmp_ram_rd_en = 1; I2 = 9'd10;
        @(posedge rd_clk);
        #1;
        #1;

        check_outputs(256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF);


        @(posedge rd_clk);
        I2 = 9'd11;
        @(posedge rd_clk);
        #1;
        #1;

        check_outputs(256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Influence of Select Signal Q");
        reset_dut();


        @(posedge wr_clk);
        I1 = 1; O2 = 9'd100; din = 256'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
        @(posedge wr_clk);
        I1 = 0;


        @(posedge rd_clk);
        tmp_ram_rd_en = 1;
        I2 = 9'd100;
        Q = 1;
        @(posedge rd_clk);
        #1;


        #1;



        check_outputs(256'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Read Enable deassertion");
        reset_dut();


        @(posedge wr_clk);
        I1 = 1; O2 = 9'd20; din = 256'hFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000;
        @(posedge wr_clk);
        I1 = 0;


        @(posedge rd_clk);
        tmp_ram_rd_en = 0;
        I2 = 9'd20;
        @(posedge rd_clk);
        #1;

        if (DOUTB !== 256'hFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000) begin
             $display("PASS: Read inhibited when enable is low");
             pass_count = pass_count + 1;
        end else begin
             $display("FAIL: Read occurred despite enable being low");
             fail_count = fail_count + 1;
        end
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
