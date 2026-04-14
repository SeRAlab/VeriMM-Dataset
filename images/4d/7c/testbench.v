`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] Q;
    reg clk;
    reg [11:0] count_d1_reg;
    reg [8:0] din;
    reg out;
    reg ram_full_fb_i_reg;
    reg tmp_ram_rd_en;
    wire [8:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
        .count_d1_reg(count_d1_reg),
        .din(din),
        .out(out),
        .ram_full_fb_i_reg(ram_full_fb_i_reg),
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
            ram_full_fb_i_reg = 1;
            out = 0;
            tmp_ram_rd_en = 0;
            din = 0;
            Q = 0;
            count_d1_reg = 0;
            @(posedge clk);
            #1;
            ram_full_fb_i_reg = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            din = 9'h0A5;
            out = 1;
            @(posedge clk);
            #1;
            out = 0;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h0A5);
            tmp_ram_rd_en = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes and Reads", test_num);
            reset_dut();


            din = 9'h111; out = 1; @(posedge clk); #1;
            din = 9'h122; out = 1; @(posedge clk); #1;
            din = 9'h133; out = 1; @(posedge clk); #1;
            out = 0;


            tmp_ram_rd_en = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(9'h133);
            tmp_ram_rd_en = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Capacity (16 entries)", test_num);
            reset_dut();


            out = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i[8:0];
                @(posedge clk);
                #1;
            end
            out = 0;


            tmp_ram_rd_en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(9'd15);
            tmp_ram_rd_en = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Integrity with Count Logic", test_num);
            reset_dut();


            count_d1_reg = 12'h001;
            Q = 12'h00A;


            din = 9'h1FF;
            out = 1;
            @(posedge clk); #1;
            out = 0;

            tmp_ram_rd_en = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(9'h1FF);
            tmp_ram_rd_en = 0;
            @(posedge clk);
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
        input [8:0] expected_dout;
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
        $dumpvars(0,Q, clk, count_d1_reg, din, out, ram_full_fb_i_reg, tmp_ram_rd_en, dout);
    end

endmodule
