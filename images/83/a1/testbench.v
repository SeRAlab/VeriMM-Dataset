`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr0;
    reg [4:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [575:0] data0;
    reg [575:0] data1;
    reg we0;
    reg we1;
    wire [575:0] q0;
    wire [575:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .we0(we0),
        .we1(we1),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 5'b0;
            addr1 = 5'b0;
            ce0 = 1'b0;
            ce1 = 1'b0;
            data0 = 576'b0;
            data1 = 576'b0;
            we0 = 1'b0;
            we1 = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        reg [575:0] val;
        begin
            reset_dut();
            test_num = 1;
            val = {72{8'hA5}};


            @(posedge clk);
            addr0 = 5'd5;
            data0 = val;
            ce0 = 1;
            we0 = 1;

            @(posedge clk);

            we0 = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(val, 576'b0);
        end
        endtask

    task testcase002;

        reg [575:0] val;
        begin
            reset_dut();
            test_num = 2;
            val = {72{8'h5A}};


            @(posedge clk);
            addr1 = 5'd12;
            data1 = val;
            ce1 = 1;
            we1 = 1;

            @(posedge clk);

            we1 = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(576'b0, val);
        end
        endtask

    task testcase003;

        reg [575:0] val0, val1;
        begin
            reset_dut();
            test_num = 3;
            val0 = {144{4'h1}};
            val1 = {144{4'h2}};


            @(posedge clk);
            ce0 = 1; we0 = 1; addr0 = 5'd0; data0 = val0;
            ce1 = 1; we1 = 1; addr1 = 5'd19; data1 = val1;

            @(posedge clk);

            we0 = 0; we1 = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(val0, val1);
        end
        endtask

    task testcase004;

        reg [575:0] val_init, val_new;
        begin
            reset_dut();
            test_num = 4;
            val_init = {144{4'hE}};
            val_new = {144{4'hF}};


            @(posedge clk);
            ce1 = 1; we1 = 1; addr1 = 5'd10; data1 = val_init;
            @(posedge clk);


            we1 = 0;
            ce0 = 1; we0 = 1; addr0 = 5'd2; data0 = val_new;
            @(posedge clk);


            we0 = 0;
            addr1 = 5'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(val_new, val_new);
        end
        endtask

    task testcase005;

        reg [575:0] val_attempt;
        begin
            reset_dut();
            test_num = 5;
            val_attempt = {144{4'h7}};


            @(posedge clk);
            ce0 = 0; we0 = 1; addr0 = 5'd7; data0 = val_attempt;
            @(posedge clk);


            ce0 = 1; we0 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(576'b0, 576'b0);
        end
        endtask

    task testcase006;

        reg [575:0] val;
        begin
            reset_dut();
            test_num = 6;
            val = {144{4'hD}};


            @(posedge clk);
            ce0 = 1; we0 = 1; addr0 = 5'd15; data0 = val;
            @(posedge clk);


            we0 = 0;
            ce1 = 1; we1 = 0; addr1 = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(val, val);
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
        input [575:0] expected_q0;
        input [575:0] expected_q1;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h",
                         q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h",
                         expected_q0, expected_q1);
                $display("  Got:      q0=%h, q1=%h",
                         q0, q1);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, data0, data1, we0, we1, q0, q1);
    end

endmodule
