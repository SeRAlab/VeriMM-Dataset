`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [5:0] alufn;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire n;
    wire [7:0] s;
    wire v;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alufn(alufn),
        .b(b),
        .clk(clk),
        .rst(rst),
        .n(n),
        .s(s),
        .v(v),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            rst = 1; a = 0; b = 0; alufn = 0;
            @(posedge clk);
            #1 rst = 0;
            a = 8'd10; b = 8'd20; alufn = 6'b000000;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h1E, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'd10; b = 8'd20; alufn = 6'b000001;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h1F, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'd10; b = 8'd5; alufn = 6'b000010;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h32, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'd120; b = 8'd10; alufn = 6'b000000;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h82, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'h88;
            b = 8'hF6;
            alufn = 6'b000000;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h7E, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'hFF;
            b = 8'h01;
            alufn = 6'b000000;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'h00; b = 8'hFF; alufn = 6'b000010;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            a = 8'd20; b = 8'd10; alufn = 6'b000010;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 8'hC8, 1'b0, 1'b0);
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
        input expected_n;
        input [7:0] expected_s;
        input expected_v;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_s === (expected_s ^ s ^ expected_s) &&
                expected_v === (expected_v ^ v ^ expected_v) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: n=%b, s=%h, v=%b, z=%b",
                         n, s, v, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b, s=%h, v=%b, z=%b",
                         expected_n, expected_s, expected_v, expected_z);
                $display("  Got:      n=%b, s=%h, v=%b, z=%b",
                         n, s, v, z);
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
