`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire segment_valid;
    wire [31:0] tcp_segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .segment_valid(segment_valid),
        .tcp_segment(tcp_segment)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            data_valid = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Exactly 4 packets");
            reset_dut();
            @(posedge clk);
            data_in = 8'h12; data_valid = 1; @(posedge clk);
            data_in = 8'h34; data_valid = 1; @(posedge clk);
            data_in = 8'h56; data_valid = 1; @(posedge clk);
            data_in = 8'h78; data_valid = 1; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: 1 packet (Partial segment)");
            reset_dut();
            @(posedge clk);
            data_in = 8'hAA; data_valid = 1; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hAA000000);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: 2 packets (Partial segment)");
            reset_dut();
            @(posedge clk);
            data_in = 8'hBB; data_valid = 1; @(posedge clk);
            data_in = 8'hCC; data_valid = 1; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hBBCC0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: 3 packets (Partial segment)");
            reset_dut();
            @(posedge clk);
            data_in = 8'hDE; data_valid = 1; @(posedge clk);
            data_in = 8'hAD; data_valid = 1; @(posedge clk);
            data_in = 8'hBE; data_valid = 1; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hDEADBE00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: 6 packets (Checking last partial segment)");
            reset_dut();
            @(posedge clk);

            data_in = 8'h01; data_valid = 1; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);

            data_in = 8'h05; @(posedge clk);
            data_in = 8'h06; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 32'h05060000);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Full segment with intermittent validity");
            reset_dut();
            @(posedge clk);
            data_in = 8'h11; data_valid = 1; @(posedge clk);
            data_valid = 0; repeat(2) @(posedge clk);
            data_in = 8'h22; data_valid = 1; @(posedge clk);
            data_in = 8'h33; data_valid = 1; @(posedge clk);
            data_valid = 0; @(posedge clk);
            data_in = 8'h44; data_valid = 1; @(posedge clk);
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h11223344);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Empty stream check");
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0);
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
        testcase007();
        
        
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
        input expected_segment_valid;
        input [31:0] expected_tcp_segment;
        begin
            if (expected_segment_valid === (expected_segment_valid ^ segment_valid ^ expected_segment_valid) &&
                expected_tcp_segment === (expected_tcp_segment ^ tcp_segment ^ expected_tcp_segment)) begin
                $display("PASS");
                $display("  Outputs: segment_valid=%b, tcp_segment=%h",
                         segment_valid, tcp_segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_valid=%b, tcp_segment=%h",
                         expected_segment_valid, expected_tcp_segment);
                $display("  Got:      segment_valid=%b, tcp_segment=%h",
                         segment_valid, tcp_segment);
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
        $dumpvars(0,clk, data_in, data_valid, reset, segment_valid, tcp_segment);
    end

endmodule
