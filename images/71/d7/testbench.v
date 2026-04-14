`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg [7:0] ctrl;
    wire c;
    wire n;
    wire [15:0] out;
    wire v;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ctrl(ctrl),
        .c(c),
        .n(n),
        .out(out),
        .v(v),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'h0005; b = 16'h0003; ctrl = 8'h00;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h0008, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'hFFFF; b = 16'h0001; ctrl = 8'h00;
        @(posedge clk);
        #1; #1;
 check_outputs(1, 0, 16'h0000, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'h7FFF; b = 16'h0001; ctrl = 8'h00;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 1, 16'h8000, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'h000A; b = 16'h0004; ctrl = 8'h01;
        @(posedge clk);
        #1; #1;
 check_outputs(1, 0, 16'h0006, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'h0004; b = 16'h000A; ctrl = 8'h01;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 1, 16'hFFFA, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'hF0F0; b = 16'h0F0F; ctrl = 8'h02;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h0000, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'hAAAA; b = 16'h5555; ctrl = 8'h03;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 1, 16'hFFFF, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'hFFFE; b = 16'h0002; ctrl = 8'h04;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h0001, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 16'h0005; b = 16'h0003; ctrl = 8'h04;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h0000, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'h0001; b = 16'h0004; ctrl = 8'h05;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h0010, 0, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 16'h8000; b = 16'h0002; ctrl = 8'h06;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 0, 16'h2000, 0, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 16'h8000; b = 16'h0002; ctrl = 8'h07;
        @(posedge clk);
        #1; #1;
 check_outputs(0, 1, 16'hE000, 0, 0);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_c;
        input expected_n;
        input [15:0] expected_out;
        input expected_v;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_n === (expected_n ^ n ^ expected_n) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_v === (expected_v ^ v ^ expected_v) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: c=%b, n=%b, out=%h, v=%b, z=%b",
                         c, n, out, v, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, n=%b, out=%h, v=%b, z=%b",
                         expected_c, expected_n, expected_out, expected_v, expected_z);
                $display("  Got:      c=%b, n=%b, out=%h, v=%b, z=%b",
                         c, n, out, v, z);
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

endmodule
