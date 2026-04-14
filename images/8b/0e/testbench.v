`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [21:0] av_address;
    reg [3:0] av_byteenable;
    reg av_clk;
    reg av_read;
    reg av_rst;
    reg av_write;
    reg [31:0] av_writedata;
    reg [68:0] rcn_in;
    wire [31:0] av_readdata;
    wire av_readdatavalid;
    wire av_waitrequest;
    wire [68:0] rcn_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .av_address(av_address),
        .av_byteenable(av_byteenable),
        .av_clk(av_clk),
        .av_read(av_read),
        .av_rst(av_rst),
        .av_write(av_write),
        .av_writedata(av_writedata),
        .rcn_in(rcn_in),
        .av_readdata(av_readdata),
        .av_readdatavalid(av_readdatavalid),
        .av_waitrequest(av_waitrequest),
        .rcn_out(rcn_out)
    );

    // Clock generation (10ns period)
    initial begin
        av_clk = 0;
        forever #5 av_clk = ~av_clk;
    end

        task reset_dut;

        begin
            av_rst = 1;
            av_address = 0;
            av_byteenable = 0;
            av_read = 0;
            av_write = 0;
            av_writedata = 0;
            rcn_in = 0;
            #20;
            av_rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 69'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge av_clk);
            av_address = 22'h123456;
            av_writedata = 32'hDEADBEEF;
            av_byteenable = 4'b1111;
            av_write = 1;

            @(posedge av_clk);
            while (av_waitrequest) @(posedge av_clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, {1'b1, 1'b1, 22'h123456, 4'hF, 32'hDEADBEEF, 9'h0});

            @(posedge av_clk);
            av_write = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge av_clk);
            av_address = 22'h000AAA;
            av_byteenable = 4'b1111;
            av_read = 1;

            @(posedge av_clk);
            while (av_waitrequest) @(posedge av_clk);
            av_read = 0;


            repeat(3) @(posedge av_clk);
            rcn_in = {1'b1, 36'h0, 32'h55AA55AA};

            @(posedge av_clk);
            #1;

            #1;


            check_outputs(32'h55AA55AA, 1'b1, 1'b0, 69'h0);

            @(posedge av_clk);
            rcn_in = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge av_clk);
            av_address = 22'h3FFFFF;
            av_writedata = 32'hAABBCCDD;
            av_byteenable = 4'b0011;
            av_write = 1;

            @(posedge av_clk);
            while (av_waitrequest) @(posedge av_clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, {1'b1, 1'b1, 22'h3FFFFF, 4'h3, 32'hAABBCCDD, 9'h0});

            @(posedge av_clk);
            av_write = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge av_clk);
            av_address = 22'h000100;
            av_byteenable = 4'b1111;
            av_read = 1;

            #1;


            #1;



            check_outputs(32'h0, 1'b0, av_waitrequest, {1'b1, 1'b0, 22'h000100, 4'hF, 32'h0, 9'h0});

            @(posedge av_clk);
            av_read = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge av_clk);

            rcn_in = 69'h0;
            repeat(5) @(posedge av_clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b0, 1'b0, 69'h0);
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
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_av_readdata;
        input expected_av_readdatavalid;
        input expected_av_waitrequest;
        input [68:0] expected_rcn_out;
        begin
            if (expected_av_readdata === (expected_av_readdata ^ av_readdata ^ expected_av_readdata) &&
                expected_av_readdatavalid === (expected_av_readdatavalid ^ av_readdatavalid ^ expected_av_readdatavalid) &&
                expected_av_waitrequest === (expected_av_waitrequest ^ av_waitrequest ^ expected_av_waitrequest) &&
                expected_rcn_out === (expected_rcn_out ^ rcn_out ^ expected_rcn_out)) begin
                $display("PASS");
                $display("  Outputs: av_readdata=%h, av_readdatavalid=%b, av_waitrequest=%b, rcn_out=%h",
                         av_readdata, av_readdatavalid, av_waitrequest, rcn_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: av_readdata=%h, av_readdatavalid=%b, av_waitrequest=%b, rcn_out=%h",
                         expected_av_readdata, expected_av_readdatavalid, expected_av_waitrequest, expected_rcn_out);
                $display("  Got:      av_readdata=%h, av_readdatavalid=%b, av_waitrequest=%b, rcn_out=%h",
                         av_readdata, av_readdatavalid, av_waitrequest, rcn_out);
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
        $dumpvars(0,av_address, av_byteenable, av_clk, av_read, av_rst, av_write, av_writedata, rcn_in, av_readdata, av_readdatavalid, av_waitrequest, rcn_out);
    end

endmodule
