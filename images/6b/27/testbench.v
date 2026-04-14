`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg din_en;
    reg dout_en;
    reg rst;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .din_en(din_en),
        .dout_en(dout_en),
        .rst(rst),
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
            din = 0;
            din_en = 0;
            dout_en = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            din = 32'hABCD_1234;
            din_en = 1;
            @(posedge clk);
            din_en = 0;


            @(posedge clk);
            dout_en = 1;
            @(posedge clk);
            dout_en = 0;

            $display("Testcase 001: Single Write/Read");
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            din = 32'h1111_1111; din_en = 1;
            @(posedge clk);
            din = 32'h2222_2222; din_en = 1;
            @(posedge clk);
            din = 32'h3333_3333; din_en = 1;
            @(posedge clk);
            din_en = 0;


            @(posedge clk);
            dout_en = 1;
            @(posedge clk);
            dout_en = 1;
            @(posedge clk);
            dout_en = 1;
            @(posedge clk);
            dout_en = 0;

            $display("Testcase 002: FIFO Order Verification (Checking 3rd value)");
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge clk);
                din = i;
                din_en = 1;
            end
            @(posedge clk);
            din_en = 0;


            for (i = 0; i < 512; i = i + 1) begin
                @(posedge clk);
                dout_en = 1;
            end
            @(posedge clk);
            dout_en = 0;

            $display("Testcase 003: Full Capacity Test (Reading entry 511)");
            #1;

            check_outputs(32'd511);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            for (i = 0; i < 513; i = i + 1) begin
                @(posedge clk);
                din = (i == 512) ? 32'hDEAD_BEEF : i;
                din_en = 1;
            end
            @(posedge clk);
            din_en = 0;


            @(posedge clk);
            dout_en = 1;
            @(posedge clk);
            dout_en = 0;

            $display("Testcase 004: Overflow Check (First value should remain 0)");
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            for (i = 0; i < 300; i = i + 1) begin
                @(posedge clk);
                din = i; din_en = 1;
            end
            @(posedge clk);
            din_en = 0;


            for (i = 0; i < 200; i = i + 1) begin
                @(posedge clk);
                dout_en = 1;
            end
            @(posedge clk);
            dout_en = 0;


            for (i = 0; i < 300; i = i + 1) begin
                @(posedge clk);
                din = 32'hF00D_0000 + i;
                din_en = 1;
            end
            @(posedge clk);
            din_en = 0;


            for (i = 0; i < 400; i = i + 1) begin
                @(posedge clk);
                dout_en = 1;
            end
            @(posedge clk);
            dout_en = 0;

            $display("Testcase 005: Pointer Wrap-around (Checking last written value)");
            #1;

            check_outputs(32'hF00D_0000 + 299);
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
        $dumpvars(0,clk, din, din_en, dout_en, rst, dout);
    end

endmodule
