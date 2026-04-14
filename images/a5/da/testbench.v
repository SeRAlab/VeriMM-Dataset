`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg [2:0] rd_at;
    reg [2:0] wr_at;
    reg wr_en;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_at(rd_at),
        .wr_at(wr_at),
        .wr_en(wr_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            din = 0;
            rd_at = 0;
            wr_at = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write and Read Register 0", test_num);

            wr_en = 1;
            wr_at = 3'd0;
            din = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_at = 3'd0;
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write and Read Register 1", test_num);

            wr_en = 1;
            wr_at = 3'd1;
            din = 32'h1234_5678;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_at = 3'd1;
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write and Read Register 2", test_num);

            wr_en = 1;
            wr_at = 3'd2;
            din = 32'hCAFE_BABE;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_at = 3'd2;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify Write Enable is respected", test_num);


            wr_en = 1;
            wr_at = 3'd0;
            din = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            wr_en = 0;
            din = 32'h0000_0000;
            @(posedge clk);
            #1;
            rd_at = 3'd0;
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwrite Register 1", test_num);

            wr_en = 1;
            wr_at = 3'd1;
            din = 32'h1111_1111;
            @(posedge clk);
            #1;
            din = 32'h2222_2222;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_at = 3'd1;
            #1;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Read Reg 0 while writing Reg 2", test_num);


            wr_en = 1;
            wr_at = 3'd0;
            din = 32'hDEADEAD0;
            @(posedge clk);
            #1;

            wr_at = 3'd2;
            din = 32'h2222_2222;
            rd_at = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADEAD0);
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
        $dumpvars(0,clk, din, rd_at, wr_at, wr_en, dout);
    end

endmodule
