`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst_n;
    wire [7:0] packet_out;
    wire packet_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst_n(rst_n),
        .packet_out(packet_out),
        .packet_ready(packet_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 8'h0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("Test Case 001: Full Segment Transfer");
            reset_dut();
            for (i = 1; i <= 7; i = i + 1) begin
                data_in = i;
                data_valid = 1;
                @(posedge clk);
            end

            data_in = 8'h08;
            data_valid = 1;
            #1;
            #1;

            check_outputs(8'h08, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Test Case 002: Incomplete Segment (4 bytes)");
            reset_dut();
            for (i = 1; i <= 4; i = i + 1) begin
                data_in = 8'hA0 + i;
                data_valid = 1;
                @(posedge clk);
            end
            data_valid = 0;
            #1;
            #1;

            check_outputs(8'hA4, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case 003: Gapped Data Stream");
            reset_dut();


            for (i = 1; i <= 4; i = i + 1) begin
                data_in = i;
                data_valid = 1;
                @(posedge clk);
            end


            data_valid = 0;
            data_in = 8'hFF;
            repeat(4) @(posedge clk);


            for (i = 5; i <= 7; i = i + 1) begin
                data_in = i;
                data_valid = 1;
                @(posedge clk);
            end


            data_in = 8'h88;
            data_valid = 1;
            #1;
            #1;

            check_outputs(8'h88, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case 004: Consecutive Segments");
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                data_valid = 1;
                @(posedge clk);
            end


            for (i = 1; i <= 7; i = i + 1) begin
                data_in = 8'hB0 + i;
                data_valid = 1;
                @(posedge clk);
            end


            data_in = 8'hCC;
            data_valid = 1;
            #1;
            #1;

            check_outputs(8'hCC, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test Case 005: Reset Mid-stream");
            reset_dut();


            for (i = 1; i <= 7; i = i + 1) begin
                data_in = i;
                data_valid = 1;
                @(posedge clk);
            end


            rst_n = 0;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);


            for (i = 1; i <= 7; i = i + 1) begin
                data_in = 8'hD0 + i;
                data_valid = 1;
                @(posedge clk);
            end

            data_in = 8'hDD;
            data_valid = 1;
            #1;

            #1;


            check_outputs(8'hDD, 1'b1);
            @(posedge clk);
            data_valid = 0;
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
        input [7:0] expected_packet_out;
        input expected_packet_ready;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_packet_ready === (expected_packet_ready ^ packet_ready ^ expected_packet_ready)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, packet_ready=%b",
                         packet_out, packet_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, packet_ready=%b",
                         expected_packet_out, expected_packet_ready);
                $display("  Got:      packet_out=%h, packet_ready=%b",
                         packet_out, packet_ready);
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
        $dumpvars(0,clk, data_in, data_valid, rst_n, packet_out, packet_ready);
    end

endmodule
