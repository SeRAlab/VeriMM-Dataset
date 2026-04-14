`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_valid;
    reg [15:0] mss;
    reg rst;
    wire packet_valid;
    wire segmentation_done;
    wire [31:0] tcp_packet_out;

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
        .packet_valid(packet_valid),
        .segmentation_done(segmentation_done),
        .tcp_packet_out(tcp_packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 32'b0;
            data_valid = 0;
            mss = 16'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Short stream (smaller than MSS)", test_num);
            reset_dut();

            mss = 16'd16;
            @(posedge clk);


            data_valid = 1;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);
            data_in = 32'hBBBB_BBBB;
            @(posedge clk);
            data_valid = 0;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(0, 1, 32'hBBBB_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Long stream (Multiple segments)", test_num);
            reset_dut();

            mss = 16'd8;
            @(posedge clk);

            data_valid = 1;
            data_in = 32'h1111_1111; @(posedge clk);
            data_in = 32'h2222_2222; @(posedge clk);
            data_in = 32'h3333_3333; @(posedge clk);
            data_in = 32'h4444_4444; @(posedge clk);
            data_in = 32'h5555_5555; @(posedge clk);
            data_in = 32'h6666_6666; @(posedge clk);
            data_valid = 0;


            while (!segmentation_done) @(posedge clk);


            #1;



            check_outputs(0, 1, 32'h6666_6666);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Exact MSS boundary", test_num);
            reset_dut();

            mss = 16'd16;
            @(posedge clk);

            data_valid = 1;
            data_in = 32'hDEAD_BEEF; @(posedge clk);
            data_in = 32'hCAFE_BABE; @(posedge clk);
            data_in = 32'hFEED_FACE; @(posedge clk);
            data_in = 32'h1234_5678; @(posedge clk);
            data_valid = 0;

            while (!segmentation_done) @(posedge clk);

            #1;


            check_outputs(0, 1, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Minimum data (1 word)", test_num);
            reset_dut();

            mss = 16'd64;
            @(posedge clk);

            data_valid = 1;
            data_in = 32'hFFFF_FFFF; @(posedge clk);
            data_valid = 0;

            while (!segmentation_done) @(posedge clk);

            #1;


            check_outputs(0, 1, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();

            mss = 16'd32;
            @(posedge clk);
            data_valid = 1;
            data_in = 32'h8888_8888;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            #1;



            check_outputs(0, 0, 0);
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
        input expected_packet_valid;
        input expected_segmentation_done;
        input [31:0] expected_tcp_packet_out;
        begin
            if (expected_packet_valid === (expected_packet_valid ^ packet_valid ^ expected_packet_valid) &&
                expected_segmentation_done === (expected_segmentation_done ^ segmentation_done ^ expected_segmentation_done) &&
                expected_tcp_packet_out === (expected_tcp_packet_out ^ tcp_packet_out ^ expected_tcp_packet_out)) begin
                $display("PASS");
                $display("  Outputs: packet_valid=%b, segmentation_done=%b, tcp_packet_out=%h",
                         packet_valid, segmentation_done, tcp_packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_valid=%b, segmentation_done=%b, tcp_packet_out=%h",
                         expected_packet_valid, expected_segmentation_done, expected_tcp_packet_out);
                $display("  Got:      packet_valid=%b, segmentation_done=%b, tcp_packet_out=%h",
                         packet_valid, segmentation_done, tcp_packet_out);
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
        $dumpvars(0,clk, data_in, data_valid, mss, rst, packet_valid, segmentation_done, tcp_packet_out);
    end

endmodule
