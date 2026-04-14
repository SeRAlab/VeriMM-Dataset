`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_l_tdata;
    reg [15:0] input_r_tdata;
    reg input_tvalid;
    reg rst;
    wire input_tready;
    wire sck;
    wire sd;
    wire ws;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_l_tdata(input_l_tdata),
        .input_r_tdata(input_r_tdata),
        .input_tvalid(input_tvalid),
        .rst(rst),
        .input_tready(input_tready),
        .sck(sck),
        .sd(sd),
        .ws(ws)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_tvalid = 0;
            input_l_tdata = 0;
            input_r_tdata = 0;
            #20;
            rst = 0;
            #20;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset and Idle Handshake Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Frame Transmission (All Zeros)", test_num);
            reset_dut();
            input_l_tdata = 16'h0000;
            input_r_tdata = 16'h0000;
            input_tvalid = 1;


            @(posedge clk);
            while (input_tready == 1) @(posedge clk);
            input_tvalid = 0;



            repeat (1000) begin
                @(posedge clk);
                if (input_tready == 1) break;
            end

            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Frame Transmission (All Ones)", test_num);
            reset_dut();
            input_l_tdata = 16'hFFFF;
            input_r_tdata = 16'hFFFF;
            input_tvalid = 1;

            @(posedge clk);
            while (input_tready == 1) @(posedge clk);
            input_tvalid = 0;

            repeat (1000) begin
                @(posedge clk);
                if (input_tready == 1) break;
            end

            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern Test (0xAAAA, 0x5554)", test_num);
            reset_dut();
            input_l_tdata = 16'hAAAA;
            input_r_tdata = 16'h5554;
            input_tvalid = 1;

            @(posedge clk);
            while (input_tready == 1) @(posedge clk);
            input_tvalid = 0;

            repeat (1000) begin
                @(posedge clk);
                if (input_tready == 1) break;
            end

            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Delayed Tvalid Check", test_num);
            reset_dut();
            #100;
            input_l_tdata = 16'h1234;
            input_r_tdata = 16'h5679;
            input_tvalid = 1;

            @(posedge clk);
            while (input_tready == 1) @(posedge clk);
            input_tvalid = 0;

            repeat (1000) begin
                @(posedge clk);
                if (input_tready == 1) break;
            end

            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
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
        input expected_input_tready;
        input expected_sck;
        input expected_sd;
        input expected_ws;
        begin
            if (expected_input_tready === (expected_input_tready ^ input_tready ^ expected_input_tready) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck) &&
                expected_sd === (expected_sd ^ sd ^ expected_sd) &&
                expected_ws === (expected_ws ^ ws ^ expected_ws)) begin
                $display("PASS");
                $display("  Outputs: input_tready=%b, sck=%b, sd=%b, ws=%b",
                         input_tready, sck, sd, ws);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input_tready=%b, sck=%b, sd=%b, ws=%b",
                         expected_input_tready, expected_sck, expected_sd, expected_ws);
                $display("  Got:      input_tready=%b, sck=%b, sd=%b, ws=%b",
                         input_tready, sck, sd, ws);
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
        $dumpvars(0,clk, input_l_tdata, input_r_tdata, input_tvalid, rst, input_tready, sck, sd, ws);
    end

endmodule
