`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg data_valid;
    reg rst;
    wire [127:0] segment_out;
    wire segment_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
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
            rst = 1;
            data_in = 0;
            data_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single segment transfer", test_num);
            reset_dut();

            data_in = 128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            data_in = 0;


            @(posedge clk);
            #1;

            #1;


            check_outputs(128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Back-to-back segments", test_num);
            reset_dut();


            data_in = 128'h1111_1111_2222_2222_3333_3333_4444_4444;
            data_valid = 1;
            @(posedge clk);
            #1;


            data_in = 128'h5555_5555_6666_6666_7777_7777_8888_8888;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_valid = 0;
            data_in = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(128'h5555_5555_6666_6666_7777_7777_8888_8888, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Intermittent valid signals", test_num);
            reset_dut();

            data_in = 128'hFEED_FACE_CAFE_BABE_DEAD_BEEF_0000_FFFF;
            data_valid = 1;
            @(posedge clk);
            #1;

            data_valid = 0;
            data_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(128'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during operation", test_num);
            reset_dut();

            data_in = 128'hDEAF_BEEF_DEAF_BEEF_DEAF_BEEF_DEAF_BEEF;
            data_valid = 1;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(128'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros data", test_num);
            reset_dut();

            data_in = 128'h0;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0, 1'b1);
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
        input [127:0] expected_segment_out;
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
        $dumpvars(0,clk, data_in, data_valid, rst, segment_out, segment_valid);
    end

endmodule
