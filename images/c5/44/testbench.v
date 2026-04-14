`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dn;
    reg in1;
    reg in2;
    reg n_rst;
    reg up;
    wire [31:0] cnt;
    wire [3:0] cnt_1k;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .dn(dn),
        .in1(in1),
        .in2(in2),
        .n_rst(n_rst),
        .up(up),
        .cnt(cnt),
        .cnt_1k(cnt_1k),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        n_rst = 1;
        up = 0;
        dn = 0;
        in1 = 0;
        in2 = 0;
        repeat(2) @(posedge clk);
        #1;
        n_rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Basic Reset");
        reset_dut();

        #1;


        check_outputs(32'd0, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Count Up (15 cycles)");
        reset_dut();
        up = 1;
        dn = 0;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd15, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Count Down (Starting from reset)");
        reset_dut();
        up = 0;
        dn = 1;
        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(32'hFFFFFFFB, 4'd7, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Hold Logic (up=0, dn=0)");
        reset_dut();
        up = 1; dn = 0;
        repeat(10) @(posedge clk);
        up = 0; dn = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Hold Logic (up=1, dn=1)");
        reset_dut();
        up = 1; dn = 0;
        repeat(20) @(posedge clk);
        up = 1; dn = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd20, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: cnt_1k boundary check (1000)");
        reset_dut();
        up = 1; dn = 0;
        repeat(1005) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd1005, 4'd1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Ignored Inputs Check");
        reset_dut();
        up = 1; dn = 0;
        in1 = 1; in2 = 1;
        repeat(5) @(posedge clk);
        in1 = 0; in2 = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd10, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Up-Down Sequence");
        reset_dut();
        up = 1; dn = 0;
        repeat(50) @(posedge clk);
        up = 0; dn = 1;
        repeat(20) @(posedge clk);
        up = 0; dn = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(32'd30, 4'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: cnt_1k higher value (15000)");
        reset_dut();
        up = 1; dn = 0;
        repeat(15000) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd15000, 4'd15, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: cnt_1k 4-bit wrap (16000)");
        reset_dut();
        up = 1; dn = 0;
        repeat(16000) @(posedge clk);
        #1;

        #1;


        check_outputs(32'd16000, 4'd0, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_cnt;
        input [3:0] expected_cnt_1k;
        input expected_out1;
        input expected_out2;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt) &&
                expected_cnt_1k === (expected_cnt_1k ^ cnt_1k ^ expected_cnt_1k) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         cnt, cnt_1k, out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         expected_cnt, expected_cnt_1k, expected_out1, expected_out2);
                $display("  Got:      cnt=%h, cnt_1k=%h, out1=%b, out2=%b",
                         cnt, cnt_1k, out1, out2);
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
        $dumpvars(0,clk, dn, in1, in2, n_rst, up, cnt, cnt_1k, out1, out2);
    end

endmodule
