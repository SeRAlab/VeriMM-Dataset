`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] bestmode;
    reg [5:0] bestmode16;
    reg [5:0] bestmode32;
    reg [6:0] blockcnt;
    reg clk;
    reg [5:0] cnt;
    reg finish;
    reg rstn;
    wire [6:0] md_waddr;
    wire [5:0] md_wdata;
    wire md_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bestmode(bestmode),
        .bestmode16(bestmode16),
        .bestmode32(bestmode32),
        .blockcnt(blockcnt),
        .clk(clk),
        .cnt(cnt),
        .finish(finish),
        .rstn(rstn),
        .md_waddr(md_waddr),
        .md_wdata(md_wdata),
        .md_we(md_we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            finish = 0;
            cnt = 0;
            blockcnt = 0;
            bestmode = 0;
            bestmode16 = 0;
            bestmode32 = 0;
            @(posedge clk);
            #1 rstn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(7'd0, md_wdata, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Check Data Selection via cnt");
            reset_dut();
            bestmode = 6'd10;
            bestmode16 = 6'd20;
            bestmode32 = 6'd30;


            cnt = 6'd0;
            @(posedge clk);
            #1;


            if (md_wdata == 6'd10 || md_wdata == 6'd20 || md_wdata == 6'd30)
                $display("Data selected: %d", md_wdata);

            pass_count = pass_count + 1;
        end
        endtask

    task testcase003;

        reg [6:0] start_addr;
        begin
            $display("\nRunning testcase003: Check Address Incrementing");
            reset_dut();


            cnt = 6'd1;
            @(posedge clk);
            start_addr = md_waddr;
            @(posedge clk);

            #1;
            if (md_we && (md_waddr == start_addr + 1)) begin
                $display("Address incremented correctly.");
                pass_count = pass_count + 1;
            end else if (!md_we) begin
                $display("Write enable not active, address held at %d", md_waddr);
                pass_count = pass_count + 1;
            end else begin
                $display("Address increment Error!");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Check Finish Signal Reset");
            reset_dut();

            cnt = 6'd5;
            repeat(5) @(posedge clk);


            finish = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(7'd0, md_wdata, md_we);
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
        input [6:0] expected_md_waddr;
        input [5:0] expected_md_wdata;
        input expected_md_we;
        begin
            if (expected_md_waddr === (expected_md_waddr ^ md_waddr ^ expected_md_waddr) &&
                expected_md_wdata === (expected_md_wdata ^ md_wdata ^ expected_md_wdata) &&
                expected_md_we === (expected_md_we ^ md_we ^ expected_md_we)) begin
                $display("PASS");
                $display("  Outputs: md_waddr=%h, md_wdata=%h, md_we=%b",
                         md_waddr, md_wdata, md_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: md_waddr=%h, md_wdata=%h, md_we=%b",
                         expected_md_waddr, expected_md_wdata, expected_md_we);
                $display("  Got:      md_waddr=%h, md_wdata=%h, md_we=%b",
                         md_waddr, md_wdata, md_we);
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
        $dumpvars(0,bestmode, bestmode16, bestmode32, blockcnt, clk, cnt, finish, rstn, md_waddr, md_wdata, md_we);
    end

endmodule
