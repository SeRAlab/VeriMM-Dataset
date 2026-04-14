`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cend;
    reg clk;
    reg fetch_end;
    reg fetch_start;
    reg pre_cend;
    reg [15:0] video_data;
    reg video_strobe;
    reg vpix;
    wire fetch_sync;
    wire [63:0] pic_bits;
    wire video_go;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cend(cend),
        .clk(clk),
        .fetch_end(fetch_end),
        .fetch_start(fetch_start),
        .pre_cend(pre_cend),
        .video_data(video_data),
        .video_strobe(video_strobe),
        .vpix(vpix),
        .fetch_sync(fetch_sync),
        .pic_bits(pic_bits),
        .video_go(video_go)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cend = 0;
            fetch_end = 0;
            fetch_start = 0;
            pre_cend = 0;
            video_data = 16'h0;
            video_strobe = 0;
            vpix = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Sync Toggle", test_num);
            reset_dut();

            fetch_start = 1;
            @(posedge clk);
            #1 fetch_start = 0;

            repeat(2) @(posedge clk);

            fetch_end = 1;
            @(posedge clk);
            #1 fetch_end = 0;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, 64'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Video Go logic", test_num);
            reset_dut();

            fetch_start = 1;
            @(posedge clk);
            #1 fetch_start = 0;

            vpix = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 64'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Data assembly (64-bit)", test_num);
            reset_dut();

            fetch_start = 1;
            @(posedge clk);
            #1 fetch_start = 0;
            vpix = 1;


            video_data = 16'hAAAA;
            video_strobe = 1;
            @(posedge clk); #1; video_strobe = 0; @(posedge clk); #1;


            video_data = 16'hBBBB;
            video_strobe = 1;
            @(posedge clk); #1; video_strobe = 0; @(posedge clk); #1;


            video_data = 16'hCCCC;
            video_strobe = 1;
            @(posedge clk); #1; video_strobe = 0; @(posedge clk); #1;


            video_data = 16'hDDDD;
            video_strobe = 1;
            @(posedge clk); #1; video_strobe = 0; @(posedge clk); #1;


            #1;



            check_outputs(1'b1, 64'hAAAABBBBCCCCDDDD, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: End Fetch Cycle", test_num);
            reset_dut();

            fetch_start = 1;
            @(posedge clk);
            #1 fetch_start = 0;
            vpix = 1;

            repeat(2) @(posedge clk);

            fetch_end = 1;
            vpix = 0;
            @(posedge clk);
            #1 fetch_end = 0;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b0, pic_bits, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_fetch_sync;
        input [63:0] expected_pic_bits;
        input expected_video_go;
        begin
            if (expected_fetch_sync === (expected_fetch_sync ^ fetch_sync ^ expected_fetch_sync) &&
                expected_pic_bits === (expected_pic_bits ^ pic_bits ^ expected_pic_bits) &&
                expected_video_go === (expected_video_go ^ video_go ^ expected_video_go)) begin
                $display("PASS");
                $display("  Outputs: fetch_sync=%b, pic_bits=%h, video_go=%b",
                         fetch_sync, pic_bits, video_go);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fetch_sync=%b, pic_bits=%h, video_go=%b",
                         expected_fetch_sync, expected_pic_bits, expected_video_go);
                $display("  Got:      fetch_sync=%b, pic_bits=%h, video_go=%b",
                         fetch_sync, pic_bits, video_go);
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
        $dumpvars(0,cend, clk, fetch_end, fetch_start, pre_cend, video_data, video_strobe, vpix, fetch_sync, pic_bits, video_go);
    end

endmodule
