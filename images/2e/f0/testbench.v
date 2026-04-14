`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] length;
    reg [7:0] mss;
    reg reset;
    reg [255:0] tcp_payload;
    wire [7:0] num_segments;
    wire [7:0] segment_length;
    wire [255:0] segment_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .length(length),
        .mss(mss),
        .reset(reset),
        .tcp_payload(tcp_payload),
        .num_segments(num_segments),
        .segment_length(segment_length),
        .segment_out(segment_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            length = 0;
            mss = 0;
            tcp_payload = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Perfect Division (Len: 20, MSS: 10)");
            reset_dut();
            tcp_payload = 256'h0102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F20;
            length = 8'd20;
            mss = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd2, 8'd10, 256'h0102030405060708090A00000000000000000000000000000000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Remainder Segmentation (Len: 15, MSS: 4)");
            reset_dut();
            tcp_payload = 256'hA1A2A3A4A5A6A7A8A9B1B2B3B4B5B60000000000000000000000000000000000;
            length = 8'd15;
            mss = 8'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd4, 8'd4, 256'hA1A2A3A400000000000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Single Segment (Len < MSS)");
            reset_dut();
            tcp_payload = 256'hFEEDFACECAFEBEEF010200000000000000000000000000000000000000000000;
            length = 8'd10;
            mss = 8'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1, 8'd10, 256'hFEEDFACECAFEBEEF010200000000000000000000000000000000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Exact Match (Len == MSS)");
            reset_dut();
            tcp_payload = 256'h1122334455667788000000000000000000000000000000000000000000000000;
            length = 8'd8;
            mss = 8'd8;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1, 8'd8, 256'h1122334455667788000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Minimum MSS (MSS: 1)");
            reset_dut();
            tcp_payload = 256'hAA55FF0000000000000000000000000000000000000000000000000000000000;
            length = 8'd3;
            mss = 8'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd3, 8'd1, 256'hAA00000000000000000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Maximum payload width (Len: 32, MSS: 16)");
            reset_dut();
            tcp_payload = 256'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC_BBBBBBBB_AAAAAAAA_99999999_88888888;
            length = 8'd32;
            mss = 8'd16;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd2, 8'd16, 256'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC_00000000_00000000_00000000_00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [7:0] expected_num_segments;
        input [7:0] expected_segment_length;
        input [255:0] expected_segment_out;
        begin
            if (expected_num_segments === (expected_num_segments ^ num_segments ^ expected_num_segments) &&
                expected_segment_length === (expected_segment_length ^ segment_length ^ expected_segment_length) &&
                expected_segment_out === (expected_segment_out ^ segment_out ^ expected_segment_out)) begin
                $display("PASS");
                $display("  Outputs: num_segments=%h, segment_length=%h, segment_out=%h",
                         num_segments, segment_length, segment_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_segments=%h, segment_length=%h, segment_out=%h",
                         expected_num_segments, expected_segment_length, expected_segment_out);
                $display("  Got:      num_segments=%h, segment_length=%h, segment_out=%h",
                         num_segments, segment_length, segment_out);
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
        $dumpvars(0,clk, length, mss, reset, tcp_payload, num_segments, segment_length, segment_out);
    end

endmodule
