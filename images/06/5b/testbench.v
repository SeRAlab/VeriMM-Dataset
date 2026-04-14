`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [15:0] mss;
    reg new_data;
    reg rst_n;
    wire [31:0] segment_out;
    wire segment_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .mss(mss),
        .new_data(new_data),
        .rst_n(rst_n),
        .segment_out(segment_out),
        .segment_valid(segment_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            mss = 0;
            new_data = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\ntestcase001: MSS = 4 (Single Word Segment)");
            reset_dut();
            test_num = 1;
            mss = 16'd4;
            data_in = 32'hAAAA_BBBB;
            new_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 1'b1);
            new_data = 0;
        end
        endtask

    task testcase002;

        begin
            $display("\ntestcase002: MSS = 8 (Double Word Segment)");
            reset_dut();
            test_num = 2;
            mss = 16'd8;


            data_in = 32'h1111_1111;
            new_data = 1;
            @(posedge clk);


            data_in = 32'h2222_2222;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h2222_2222, 1'b1);
            new_data = 0;
        end
        endtask

    task testcase003;

        begin
            $display("\ntestcase003: MSS = 16 (4-Word Segment)");
            reset_dut();
            test_num = 3;
            mss = 16'd16;
            new_data = 1;

            data_in = 32'hD000_0001; @(posedge clk);
            data_in = 32'hD000_0002; @(posedge clk);
            data_in = 32'hD000_0003; @(posedge clk);
            data_in = 32'hD000_0004; @(posedge clk);

            #1;
            #1;

            check_outputs(32'hD000_0004, 1'b1);
            new_data = 0;
        end
        endtask

    task testcase004;

        begin
            $display("\ntestcase004: Data Not Ready (new_data = 0)");
            reset_dut();
            test_num = 4;
            mss = 16'd4;
            data_in = 32'hFFFF_FFFF;
            new_data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\ntestcase005: Reset mid-segment");
            reset_dut();
            test_num = 5;
            mss = 16'd12;
            new_data = 1;

            data_in = 32'hAAAA_AAAA; @(posedge clk);
            data_in = 32'hBBBB_BBBB; @(posedge clk);


            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
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
        input [31:0] expected_segment_out;
        input expected_segment_valid;
        begin
            if (expected_segment_out === (expected_segment_out ^ segment_out ^ expected_segment_out) &&
                expected_segment_valid === (expected_segment_valid ^ segment_valid ^ expected_segment_valid)) begin
                $display("PASS");
                $display("  Outputs: segment_out=%h, segment_valid=%b",
                         segment_out, segment_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_out=%h, segment_valid=%b",
                         expected_segment_out, expected_segment_valid);
                $display("  Got:      segment_out=%h, segment_valid=%b",
                         segment_out, segment_valid);
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
        $dumpvars(0,clk, data_in, mss, new_data, rst_n, segment_out, segment_valid);
    end

endmodule
