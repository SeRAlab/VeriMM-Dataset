`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr;
    reg [2:0] ba;
    reg cas_n;
    reg clk;
    reg [15:0] dq;
    reg ras_n;
    reg rst_n;
    reg we_n;
    wire [3:0] dm_i;
    wire [3:0] dm_o;
    wire [15:0] dq_i;
    wire [15:0] dq_o;
    wire [1:0] dqs_i;
    wire [1:0] dqs_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ba(ba),
        .cas_n(cas_n),
        .clk(clk),
        .dq(dq),
        .ras_n(ras_n),
        .rst_n(rst_n),
        .we_n(we_n),
        .dm_i(dm_i),
        .dm_o(dm_o),
        .dq_i(dq_i),
        .dq_o(dq_o),
        .dqs_i(dqs_i),
        .dqs_o(dqs_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            addr = 0;
            ba = 0;
            ras_n = 1;
            cas_n = 1;
            we_n = 1;
            dq = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read to Bank 0");
            test_num = test_num + 1;
            reset_dut();


            ba = 3'b000;
            addr = 13'h0123;
            ras_n = 0; cas_n = 1; we_n = 1;
            @(posedge clk);


            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(2) @(posedge clk);


            ba = 3'b000;
            addr = 13'h0004;
            dq = 16'hAAAA;
            ras_n = 1; cas_n = 0; we_n = 0;
            @(posedge clk);


            ras_n = 1; cas_n = 1; we_n = 1;
            dq = 16'hzzzz;
            repeat(5) @(posedge clk);


            ba = 3'b000;
            addr = 13'h0004;
            ras_n = 1; cas_n = 0; we_n = 1;
            @(posedge clk);


            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(5) @(posedge clk);



            #1;




            check_outputs(4'h0, 4'h0, 16'hAAAA, 16'hAAAA, 2'h0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write and Read to Bank 5");
            test_num = test_num + 1;
            reset_dut();


            ba = 3'b101;
            addr = 13'h0ABC;
            ras_n = 0; cas_n = 1; we_n = 1;
            @(posedge clk);

            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(2) @(posedge clk);


            ba = 3'b101;
            addr = 13'h0010;
            dq = 16'h5555;
            ras_n = 1; cas_n = 0; we_n = 0;
            @(posedge clk);

            ras_n = 1; cas_n = 1; we_n = 1;
            dq = 16'hzzzz;
            repeat(5) @(posedge clk);


            ba = 3'b101;
            addr = 13'h0010;
            ras_n = 1; cas_n = 0; we_n = 1;
            @(posedge clk);

            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h0, 16'h5555, 16'h5555, 2'h0, 2'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Bank Interleaving");
            test_num = test_num + 1;
            reset_dut();


            ba = 3'b000; addr = 13'h0001; ras_n = 0; cas_n = 1; we_n = 1; @(posedge clk);
            ras_n = 1; @(posedge clk);


            ba = 3'b001; addr = 13'h0001; ras_n = 0; cas_n = 1; we_n = 1; @(posedge clk);
            ras_n = 1; @(posedge clk);


            ba = 3'b000; addr = 13'h000A; dq = 16'h1111; ras_n = 1; cas_n = 0; we_n = 0; @(posedge clk);


            ba = 3'b001; addr = 13'h000B; dq = 16'h2222; ras_n = 1; cas_n = 0; we_n = 0; @(posedge clk);

            ras_n = 1; cas_n = 1; we_n = 1; dq = 16'hzzzz;
            repeat(5) @(posedge clk);


            ba = 3'b000; addr = 13'h000A; ras_n = 1; cas_n = 0; we_n = 1; @(posedge clk);
            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(5) @(posedge clk);


            ba = 3'b001; addr = 13'h000B; ras_n = 1; cas_n = 0; we_n = 1; @(posedge clk);
            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h0, 16'h2222, 16'h2222, 2'h0, 2'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Data Overwrite");
            test_num = test_num + 1;
            reset_dut();


            ba = 3'b010; addr = 13'h0001; ras_n = 0; cas_n = 1; we_n = 1; @(posedge clk);
            ras_n = 1; @(posedge clk);


            ba = 3'b010; addr = 13'h0050; dq = 16'hDEAD; ras_n = 1; cas_n = 0; we_n = 0; @(posedge clk);
            ras_n = 1; cas_n = 1; we_n = 1; @(posedge clk);


            ba = 3'b010; addr = 13'h0050; dq = 16'hBEEF; ras_n = 1; cas_n = 0; we_n = 0; @(posedge clk);
            ras_n = 1; cas_n = 1; we_n = 1; dq = 16'hzzzz;
            repeat(5) @(posedge clk);


            ba = 3'b010; addr = 13'h0050; ras_n = 1; cas_n = 0; we_n = 1; @(posedge clk);
            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h0, 16'hBEEF, 16'hBEEF, 2'h0, 2'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset and Idle State");
            test_num = test_num + 1;
            reset_dut();


            ras_n = 1; cas_n = 1; we_n = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h0, 4'h0, 16'h0000, 16'h0000, 2'h0, 2'h0);
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
        input [3:0] expected_dm_i;
        input [3:0] expected_dm_o;
        input [15:0] expected_dq_i;
        input [15:0] expected_dq_o;
        input [1:0] expected_dqs_i;
        input [1:0] expected_dqs_o;
        begin
            if (expected_dm_i === (expected_dm_i ^ dm_i ^ expected_dm_i) &&
                expected_dm_o === (expected_dm_o ^ dm_o ^ expected_dm_o) &&
                expected_dq_i === (expected_dq_i ^ dq_i ^ expected_dq_i) &&
                expected_dq_o === (expected_dq_o ^ dq_o ^ expected_dq_o) &&
                expected_dqs_i === (expected_dqs_i ^ dqs_i ^ expected_dqs_i) &&
                expected_dqs_o === (expected_dqs_o ^ dqs_o ^ expected_dqs_o)) begin
                $display("PASS");
                $display("  Outputs: dm_i=%h, dm_o=%h, dq_i=%h, dq_o=%h, dqs_i=%h, dqs_o=%h",
                         dm_i, dm_o, dq_i, dq_o, dqs_i, dqs_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dm_i=%h, dm_o=%h, dq_i=%h, dq_o=%h, dqs_i=%h, dqs_o=%h",
                         expected_dm_i, expected_dm_o, expected_dq_i, expected_dq_o, expected_dqs_i, expected_dqs_o);
                $display("  Got:      dm_i=%h, dm_o=%h, dq_i=%h, dq_o=%h, dqs_i=%h, dqs_o=%h",
                         dm_i, dm_o, dq_i, dq_o, dqs_i, dqs_o);
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
        $dumpvars(0,addr, ba, cas_n, clk, dq, ras_n, rst_n, we_n, dm_i, dm_o, dq_i, dq_o, dqs_i, dqs_o);
    end

endmodule
