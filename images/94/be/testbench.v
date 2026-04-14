`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg i_din;
    reg i_req;
    reg rst;
    wire o_err;
    wire o_lck;
    wire o_vld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .i_din(i_din),
        .i_req(i_req),
        .rst(rst),
        .o_err(o_err),
        .o_lck(o_lck),
        .o_vld(o_vld)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            rst = 1;
            i_req = 0;
            i_din = 0;
            repeat(2) @(posedge ck);
            #1 rst = 0;
            @(posedge ck);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] lfsr;
        reg fb;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronizing with valid PRBS8 sequence", test_num);

            lfsr = 8'hFF;
            i_req = 1;


            for (i = 0; i < 32; i = i + 1) begin
                i_din = lfsr[7];
                fb = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
                lfsr = {lfsr[6:0], fb};
                @(posedge ck);
            end

            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] lfsr;
        reg fb;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Detecting bit error after lock", test_num);

            lfsr = 8'hA5;
            i_req = 1;


            for (i = 0; i < 32; i = i + 1) begin
                i_din = lfsr[7];
                fb = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
                lfsr = {lfsr[6:0], fb};
                @(posedge ck);
            end


            i_din = ~lfsr[7];
            @(posedge ck);

            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] lfsr;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying i_req gating", test_num);

            lfsr = 8'hFF;
            i_req = 0;

            for (i = 0; i < 16; i = i + 1) begin
                i_din = lfsr[7];
                lfsr = {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
                @(posedge ck);
            end

            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] lfsr;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Recovery and continuous error check", test_num);

            lfsr = 8'h12;
            i_req = 1;


            for (i = 0; i < 32; i = i + 1) begin
                i_din = lfsr[7];
                lfsr = {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
                @(posedge ck);
            end


            for (i = 0; i < 5; i = i + 1) begin
                i_din = $random;
                @(posedge ck);
            end

            #1;

            #1;


            check_outputs(1'b1, o_lck, 1'b1);
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
        input expected_o_err;
        input expected_o_lck;
        input expected_o_vld;
        begin
            if (expected_o_err === (expected_o_err ^ o_err ^ expected_o_err) &&
                expected_o_lck === (expected_o_lck ^ o_lck ^ expected_o_lck) &&
                expected_o_vld === (expected_o_vld ^ o_vld ^ expected_o_vld)) begin
                $display("PASS");
                $display("  Outputs: o_err=%b, o_lck=%b, o_vld=%b",
                         o_err, o_lck, o_vld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_err=%b, o_lck=%b, o_vld=%b",
                         expected_o_err, expected_o_lck, expected_o_vld);
                $display("  Got:      o_err=%b, o_lck=%b, o_vld=%b",
                         o_err, o_lck, o_vld);
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
        $dumpvars(0,ck, i_din, i_req, rst, o_err, o_lck, o_vld);
    end

endmodule
