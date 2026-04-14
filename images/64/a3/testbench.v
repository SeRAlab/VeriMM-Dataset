`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [47:0] channel_din;
    reg clka;
    reg [1:0] diff_pair_din;
    reg rsta;
    wire [39:0] payload_dout;
    wire request_dout;
    wire [3:0] x_addr_dout;
    wire x_hit_dout;
    wire [3:0] y_addr_dout;
    wire y_hit_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel_din(channel_din),
        .clka(clka),
        .diff_pair_din(diff_pair_din),
        .rsta(rsta),
        .payload_dout(payload_dout),
        .request_dout(request_dout),
        .x_addr_dout(x_addr_dout),
        .x_hit_dout(x_hit_dout),
        .y_addr_dout(y_addr_dout),
        .y_hit_dout(y_hit_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            rsta = 1;
            diff_pair_din = 2'b00;
            channel_din = 48'h0;
            @(posedge clka);
            #2 rsta = 0;
            @(posedge clka);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset", test_num);
            reset_dut();

            #1;


            check_outputs(40'h0, 1'b0, 4'h0, 1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: X Hit Mode (diff_pair_din=2'b01)", test_num);
            reset_dut();


            channel_din = {4'hA, 4'hB, 40'hDEADBEEF01};
            diff_pair_din = 2'b01;

            @(posedge clka);
            #2;


            #1;



            check_outputs(40'hDEADBEEF01, 1'b1, 4'hA, 1'b1, 4'hB, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Y Hit Mode (diff_pair_din=2'b10)", test_num);
            reset_dut();


            channel_din = {4'h5, 4'h6, 40'hABCDE12345};
            diff_pair_din = 2'b10;

            @(posedge clka);
            #2;


            #1;



            check_outputs(40'hABCDE12345, 1'b1, 4'h5, 1'b0, 4'h6, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dual Hit Mode (diff_pair_din=2'b11)", test_num);
            reset_dut();

            channel_din = {4'hF, 4'hE, 40'hFFFFFFFFFF};
            diff_pair_din = 2'b11;

            @(posedge clka);
            #2;


            #1;



            check_outputs(40'hFFFFFFFFFF, 1'b1, 4'hF, 1'b1, 4'hE, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clear Mode (diff_pair_din=2'b00)", test_num);


            reset_dut();
            channel_din = {4'h1, 4'h2, 40'h1234567890};
            diff_pair_din = 2'b11;
            @(posedge clka);
            #2;


            diff_pair_din = 2'b00;
            @(posedge clka);
            #2;


            #1;



            check_outputs(40'h0, 1'b0, 4'h0, 1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive data updates", test_num);
            reset_dut();


            channel_din = {4'h1, 4'h2, 40'hAAAAAAAAAA};
            diff_pair_din = 2'b01;
            @(posedge clka);
            #2;


            channel_din = {4'h3, 4'h4, 40'hBBBBBBBBBB};
            @(posedge clka);
            #2;

            #1;


            check_outputs(40'hBBBBBBBBBB, 1'b1, 4'h3, 1'b1, 4'h4, 1'b0);
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
        input [39:0] expected_payload_dout;
        input expected_request_dout;
        input [3:0] expected_x_addr_dout;
        input expected_x_hit_dout;
        input [3:0] expected_y_addr_dout;
        input expected_y_hit_dout;
        begin
            if (expected_payload_dout === (expected_payload_dout ^ payload_dout ^ expected_payload_dout) &&
                expected_request_dout === (expected_request_dout ^ request_dout ^ expected_request_dout) &&
                expected_x_addr_dout === (expected_x_addr_dout ^ x_addr_dout ^ expected_x_addr_dout) &&
                expected_x_hit_dout === (expected_x_hit_dout ^ x_hit_dout ^ expected_x_hit_dout) &&
                expected_y_addr_dout === (expected_y_addr_dout ^ y_addr_dout ^ expected_y_addr_dout) &&
                expected_y_hit_dout === (expected_y_hit_dout ^ y_hit_dout ^ expected_y_hit_dout)) begin
                $display("PASS");
                $display("  Outputs: payload_dout=%h, request_dout=%b, x_addr_dout=%h, x_hit_dout=%b, y_addr_dout=%h, y_hit_dout=%b",
                         payload_dout, request_dout, x_addr_dout, x_hit_dout, y_addr_dout, y_hit_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: payload_dout=%h, request_dout=%b, x_addr_dout=%h, x_hit_dout=%b, y_addr_dout=%h, y_hit_dout=%b",
                         expected_payload_dout, expected_request_dout, expected_x_addr_dout, expected_x_hit_dout, expected_y_addr_dout, expected_y_hit_dout);
                $display("  Got:      payload_dout=%h, request_dout=%b, x_addr_dout=%h, x_hit_dout=%b, y_addr_dout=%h, y_hit_dout=%b",
                         payload_dout, request_dout, x_addr_dout, x_hit_dout, y_addr_dout, y_hit_dout);
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
        $dumpvars(0,channel_din, clka, diff_pair_din, rsta, payload_dout, request_dout, x_addr_dout, x_hit_dout, y_addr_dout, y_hit_dout);
    end

endmodule
