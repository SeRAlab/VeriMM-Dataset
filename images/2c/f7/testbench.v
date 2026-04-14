`timescale 1ns/1ps

module tcp_segment_sequencer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_length;
    reg [3:0] mss;
    reg reset;
    wire [3:0] num_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_sequencer dut (
        .clk(clk),
        .data_length(data_length),
        .mss(mss),
        .reset(reset),
        .num_segments(num_segments)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_length = 0;
            mss = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_length = 16'd10;
            mss = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_length = 16'd11;
            mss = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_length = 16'd0;
            mss = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_length = 16'd3;
            mss = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_length = 16'd60;
            mss = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_length = 16'd29;
            mss = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_length = 16'd1;
            mss = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data_length = 16'd15;
            mss = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segment_sequencer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_num_segments;
        begin
            if (expected_num_segments === (expected_num_segments ^ num_segments ^ expected_num_segments)) begin
                $display("PASS");
                $display("  Outputs: num_segments=%h",
                         num_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_segments=%h",
                         expected_num_segments);
                $display("  Got:      num_segments=%h",
                         num_segments);
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
        $dumpvars(0,clk, data_length, mss, reset, num_segments);
    end

endmodule
