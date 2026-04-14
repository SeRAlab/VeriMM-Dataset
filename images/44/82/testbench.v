`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] Q;
    reg clk;
    reg [63:0] din;
    reg out;
    reg ram_full_fb_i_reg;
    reg tmp_ram_rd_en;
    wire [63:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
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
            Q = 0;
            din = 0;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            out = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            Q = 12'h000;
            din = 64'h0000_0000_0000_000A;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #1;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0000_0000_0000_000A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Test (Addr 4095)", test_num);
            reset_dut();


            Q = 12'hFFF;
            din = 64'hFEDC_BA98_7654_3210;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #1;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Inhibit when Full", test_num);
            reset_dut();


            Q = 12'h100;
            din = 64'h1111_1111_1111_1111;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #1;


            ram_full_fb_i_reg = 1;
            din = 64'hEEEE_EEEE_EEEE_EEEE;
            @(posedge clk);
            #1;


            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h1111_1111_1111_1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Inhibit during Read", test_num);
            reset_dut();


            Q = 12'h200;
            din = 64'h5555_AAAA_5555_AAAA;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #1;


            tmp_ram_rd_en = 1;
            din = 64'hBBBB_BBBB_BBBB_BBBB;
            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h5555_AAAA_5555_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data Test", test_num);
            reset_dut();


            Q = 12'h005;
            din = 64'h1;
            ram_full_fb_i_reg = 0;
            tmp_ram_rd_en = 0;
            @(posedge clk);
            #1;


            din = 64'h2;
            @(posedge clk);
            #1;


            tmp_ram_rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h2);
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
        $dumpvars(0,Q, clk, din, out, ram_full_fb_i_reg, tmp_ram_rd_en, dout);
    end

endmodule
