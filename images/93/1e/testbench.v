`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    reg [3:0] d;
    reg [1023:0] v;
    reg [63:0] x;
    reg [63:0] y;
    wire [1023:0] v_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .v(v),
        .x(x),
        .y(y),
        .v_out(v_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0; b <= 0; c <= 0; d <= 0;
            v <= 0; x <= 0; y <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            v = {16{64'h0123456789ABCDEF}};
            a = 4'd0; b = 4'd1; c = 4'd2; d = 4'd3;
            x = 64'h1; y = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(calculate_expected(v, a, b, c, d, x, y));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            v = 1024'hAAAABBBBCCCCDDDD_0000111122223333_4444555566667777_88889999AAAA BBBB;
            a = 4'd15; b = 4'd14; c = 4'd13; d = 4'd12;
            x = 64'hFEEDFACECAFEBEEF;
            y = 64'h1337133713371337;
            #1;

            check_outputs(calculate_expected(v, a, b, c, d, x, y));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            v = {16{64'hFFFFFFFFFFFFFFFF}};
            a = 4'd5; b = 4'd6; c = 4'd7; d = 4'd8;
            x = 64'h1;
            y = 64'h0;
            #1;

            check_outputs(calculate_expected(v, a, b, c, d, x, y));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            v = {16{64'h5555555555555555}};
            a = 4'd10; b = 4'd10; c = 4'd2; d = 4'd2;
            x = 64'hAAAAAAAAAAAAAAAA;
            y = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(calculate_expected(v, a, b, c, d, x, y));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            v = 1024'b1;
            a = 4'd0; b = 4'd4; c = 4'd8; d = 4'd12;
            x = 64'h8000000000000000;
            y = 64'h0000000000000001;
            #1;

            check_outputs(calculate_expected(v, a, b, c, d, x, y));
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
        input [1023:0] expected_v_out;
        begin
            if (expected_v_out === (expected_v_out ^ v_out ^ expected_v_out)) begin
                $display("PASS");
                $display("  Outputs: v_out=%h",
                         v_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_out=%h",
                         expected_v_out);
                $display("  Got:      v_out=%h",
                         v_out);
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
        $dumpvars(0,a, b, c, clk, d, v, x, y, v_out);
    end

endmodule
