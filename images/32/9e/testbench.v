`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_valid;
    reg [15:0] mss;
    reg rst;
    wire [31:0] data_out;
    wire segment_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .mss(mss),
        .rst(rst),
        .data_out(data_out),
        .segment_done(segment_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            data_valid = 0;
            mss = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single segment (MSS = 4 bytes, 1 word)", test_num);
            reset_dut();
            mss = 16'd4;

            @(posedge clk);
            data_in = 32'hAABBCCDD;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hAABBCCDD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single segment (MSS = 8 bytes, 2 words)", test_num);
            reset_dut();
            mss = 16'd8;

            @(posedge clk);
            data_valid = 1;
            data_in = 32'h11111111;
            @(posedge clk);
            data_in = 32'h22222222;
            @(posedge clk);
            data_valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'h22222222, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple segments (MSS = 4 bytes, 2 words input)", test_num);
            reset_dut();
            mss = 16'd4;

            @(posedge clk);
            data_valid = 1;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);

            data_in = 32'hBBBB_BBBB;
            @(posedge clk);
            data_valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'hBBBB_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large segment (MSS = 12 bytes, 3 words input)", test_num);
            reset_dut();
            mss = 16'd12;

            @(posedge clk);
            data_valid = 1;
            data_in = 32'h10101010; @(posedge clk);
            data_in = 32'h20202020; @(posedge clk);
            data_in = 32'h30303030; @(posedge clk);
            data_valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(32'h30303030, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_segment_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_segment_done === (expected_segment_done ^ segment_done ^ expected_segment_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, segment_done=%b",
                         data_out, segment_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, segment_done=%b",
                         expected_data_out, expected_segment_done);
                $display("  Got:      data_out=%h, segment_done=%b",
                         data_out, segment_done);
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
        $dumpvars(0,clk, data_in, data_valid, mss, rst, data_out, segment_done);
    end

endmodule
