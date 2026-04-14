`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] b_sel;
    reg clk;
    reg [3:0] f_sel;
    reg fetch_stb;
    reg [15:0] video_data;
    reg video_strobe;
    wire [31:0] fetch_data;
    wire [31:0] fetch_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_sel(b_sel),
        .clk(clk),
        .f_sel(f_sel),
        .fetch_stb(fetch_stb),
        .video_data(video_data),
        .video_strobe(video_strobe),
        .fetch_data(fetch_data),
        .fetch_temp(fetch_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        b_sel = 2'b00;
        f_sel = 4'b0000;
        fetch_stb = 0;
        video_strobe = 0;
        video_data = 16'h0000;

        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Sequential byte population...");
        reset_dut();


        video_data = 16'h1122; video_strobe = 1; f_sel = 4'b0001; b_sel = 2'b00;
        @(posedge clk); #1;


        video_data = 16'h3344; video_strobe = 1; f_sel = 4'b0010; b_sel = 2'b01;
        @(posedge clk); #1;


        video_data = 16'h5566; video_strobe = 1; f_sel = 4'b0100; b_sel = 2'b00;
        @(posedge clk); #1;


        video_data = 16'h7788; video_strobe = 1; f_sel = 4'b1000; b_sel = 2'b01;
        @(posedge clk); #1;

        video_strobe = 0;


        fetch_stb = 1;
        @(posedge clk); #1;
        fetch_stb = 0;


        #1;



        check_outputs(32'h77663322, 32'h77663322);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Parallel population...");
        reset_dut();


        video_data = 16'hAA55; video_strobe = 1; f_sel = 4'b0011; b_sel = 2'b01;
        @(posedge clk); #1;


        video_data = 16'hCCDD; video_strobe = 1; f_sel = 4'b1100; b_sel = 2'b00;
        @(posedge clk); #1;

        video_strobe = 0;
        fetch_stb = 1;
        @(posedge clk); #1;
        fetch_stb = 0;


        #1;



        check_outputs(32'hDDDD_AAAA, 32'hDDDD_AAAA);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Gating and strobe persistence...");
        reset_dut();


        video_data = 16'hFFFF; video_strobe = 1; f_sel = 4'b1111; b_sel = 2'b00;
        @(posedge clk); #1;


        video_data = 16'h0000; video_strobe = 0; f_sel = 4'b1111; b_sel = 2'b01;
        @(posedge clk); #1;



        #1;




        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Partial update and fetch_stb...");
        reset_dut();


        video_data = 16'h1234; video_strobe = 1; f_sel = 4'b1111; b_sel = 2'b00;
        @(posedge clk); #1;


        fetch_stb = 1;
        @(posedge clk); #1;
        fetch_stb = 0;


        video_data = 16'h9988; video_strobe = 1; f_sel = 4'b1000; b_sel = 2'b01;
        @(posedge clk); #1;
        video_strobe = 0;



        #1;




        check_outputs(32'h34343434, 32'h99343434);
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
        input [31:0] expected_fetch_data;
        input [31:0] expected_fetch_temp;
        begin
            if (expected_fetch_data === (expected_fetch_data ^ fetch_data ^ expected_fetch_data) &&
                expected_fetch_temp === (expected_fetch_temp ^ fetch_temp ^ expected_fetch_temp)) begin
                $display("PASS");
                $display("  Outputs: fetch_data=%h, fetch_temp=%h",
                         fetch_data, fetch_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fetch_data=%h, fetch_temp=%h",
                         expected_fetch_data, expected_fetch_temp);
                $display("  Got:      fetch_data=%h, fetch_temp=%h",
                         fetch_data, fetch_temp);
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
        $dumpvars(0,b_sel, clk, f_sel, fetch_stb, video_data, video_strobe, fetch_data, fetch_temp);
    end

endmodule
