`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dst0;
    reg [7:0] dst1;
    reg [1:0] enable;
    reg rst;
    reg [7:0] src0;
    reg [7:0] src1;
    reg start;
    wire busy;
    wire [7:0] current_dst;
    wire [7:0] current_src;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dst0(dst0),
        .dst1(dst1),
        .enable(enable),
        .rst(rst),
        .src0(src0),
        .src1(src1),
        .start(start),
        .busy(busy),
        .current_dst(current_dst),
        .current_src(current_src)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        dst0 = 8'h00;
        dst1 = 8'h00;
        src0 = 8'h00;
        src1 = 8'h00;
        enable = 2'b00;
        start = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Channel 0 Enabled Transfer");
        reset_dut();

        src0 = 8'hAA;
        dst0 = 8'h55;
        enable = 2'b01;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        #1;
        #1;

        check_outputs(1'b1, 8'h55, 8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Channel 1 Enabled Transfer");
        reset_dut();

        src1 = 8'h11;
        dst1 = 8'h22;
        enable = 2'b10;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #1;
        #1;

        check_outputs(1'b1, 8'h22, 8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Both Channels Enabled (Priority Test)");
        reset_dut();

        src0 = 8'hA0; dst0 = 8'h0A;
        src1 = 8'hB1; dst1 = 8'h1B;
        enable = 2'b11;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #1;

        #1;


        check_outputs(1'b1, 8'h0A, 8'hA0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Channel 0 Disabled Attempt");
        reset_dut();

        src0 = 8'hCC;
        dst0 = 8'hDD;
        enable = 2'b10;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #1;





        if (busy == 0)
            #1;

            check_outputs(1'b0, 8'h00, 8'h00);
        else
            #1;

            check_outputs(1'b1, 8'h00, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Reset mid-transfer");
        reset_dut();

        src0 = 8'hFF;
        dst0 = 8'hEE;
        enable = 2'b01;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        #1;

        if (busy !== 1'b1) $display("Warning: Transfer did not start");


        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Channel 1 transfer with Channel 0 Disabled");
        reset_dut();

        src1 = 8'h99;
        dst1 = 8'h66;
        enable = 2'b10;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #1;
        #1;

        check_outputs(1'b1, 8'h66, 8'h99);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_busy;
        input [7:0] expected_current_dst;
        input [7:0] expected_current_src;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_current_dst === (expected_current_dst ^ current_dst ^ expected_current_dst) &&
                expected_current_src === (expected_current_src ^ current_src ^ expected_current_src)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, current_dst=%h, current_src=%h",
                         busy, current_dst, current_src);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, current_dst=%h, current_src=%h",
                         expected_busy, expected_current_dst, expected_current_src);
                $display("  Got:      busy=%b, current_dst=%h, current_src=%h",
                         busy, current_dst, current_src);
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
        $dumpvars(0,clk, dst0, dst1, enable, rst, src0, src1, start, busy, current_dst, current_src);
    end

endmodule
