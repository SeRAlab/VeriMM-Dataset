`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [15:0] segment_size;
    wire [31:0] data_out;
    wire segment_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .segment_size(segment_size),
        .data_out(data_out),
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
            segment_size = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 32'hDEADBEEF;
            segment_size = 16'd16;


            @(posedge clk);

            @(posedge clk);

            #1;
            $display("Test Case 001: 16-bit segments (Checking 2nd segment)");
            #1;

            check_outputs(32'h0000BEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 32'h12345678;
            segment_size = 16'd8;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case 002: 8-bit segments (Checking 4th segment)");
            #1;

            check_outputs(32'h00000078, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 32'hAAAA5555;
            segment_size = 16'd32;

            @(posedge clk);

            #1;
            $display("Test Case 003: 32-bit segment (Full width)");
            #1;

            check_outputs(32'hAAAA5555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 32'hFFFFFFFF;
            segment_size = 16'd16;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            $display("Test Case 004: Checking idle state after segmentation");

            #1;


            check_outputs(32'h00000000, 1'b0);
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
        input expected_segment_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_segment_valid === (expected_segment_valid ^ segment_valid ^ expected_segment_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, segment_valid=%b",
                         data_out, segment_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, segment_valid=%b",
                         expected_data_out, expected_segment_valid);
                $display("  Got:      data_out=%h, segment_valid=%b",
                         data_out, segment_valid);
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
        $dumpvars(0,clk, data_in, segment_size, data_out, segment_valid);
    end

endmodule
