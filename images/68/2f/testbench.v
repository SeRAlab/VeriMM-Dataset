`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I1;
    reg [11:0] O1;
    reg [11:0] O2;
    reg Q;
    reg [63:0] din;
    reg rd_clk;
    reg tmp_ram_rd_en;
    reg wr_clk;
    wire [63:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .O1(O1),
        .O2(O2),
        .Q(Q),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .wr_clk(wr_clk),
        .dout(dout)
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
            din = 0;
            O1 = 0;
            O2 = 0;
            repeat(5) @(posedge wr_clk);
            Q = 0;
            repeat(5) @(posedge wr_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();


            @(posedge wr_clk);
            din = 64'hAAAA_BBBB_CCCC_DDDD;
            I1 = 1;
            @(posedge wr_clk);
            I1 = 0;


            repeat(10) @(posedge rd_clk);


            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;


            #1;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Sequential Write/Read (FIFO check)", test_num);
            reset_dut();


            @(posedge wr_clk);
            din = 64'h1; I1 = 1;
            @(posedge wr_clk);
            din = 64'h2;
            @(posedge wr_clk);
            din = 64'h3;
            @(posedge wr_clk);
            I1 = 0;

            repeat(10) @(posedge rd_clk);


            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            @(posedge rd_clk);
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(64'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();


            @(posedge wr_clk);
            din = 64'hDEADBEEF; I1 = 1;
            @(posedge wr_clk);
            I1 = 0;


            reset_dut();


            repeat(5) @(posedge rd_clk);
            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;



            #1;




            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Interleaved Write and Read", test_num);
            reset_dut();


            @(posedge wr_clk);
            din = 64'hABC123; I1 = 1;
            @(posedge wr_clk);
            I1 = 0;

            repeat(10) @(posedge rd_clk);


            fork
                begin
                    @(posedge rd_clk);
                    tmp_ram_rd_en = 1;
                    @(posedge rd_clk);
                    tmp_ram_rd_en = 0;
                end
                begin
                    @(posedge wr_clk);
                    din = 64'hXYZ789; I1 = 1;
                    @(posedge wr_clk);
                    I1 = 0;
                end
            join

            repeat(10) @(posedge rd_clk);


            tmp_ram_rd_en = 1;
            @(posedge rd_clk);
            tmp_ram_rd_en = 0;

            #1;
            #1;

            check_outputs(64'hXYZ789);
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
        $dumpvars(0,I1, O1, O2, Q, din, rd_clk, tmp_ram_rd_en, wr_clk, dout);
    end

endmodule
