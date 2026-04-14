`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [1:0] op;
    reg rst;
    wire cout;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .op(op),
        .rst(rst),
        .cout(cout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in1 = 0;
            in2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Addition without carry (15 + 10)", test_num);
            in1 = 8'd15;
            in2 = 8'd10;
            op = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Addition with carry (200 + 100)", test_num);
            in1 = 8'd200;
            in2 = 8'd100;
            op = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Subtraction without borrow (50 - 20)", test_num);
            in1 = 8'd50;
            in2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Subtraction with borrow (10 - 20)", test_num);
            in1 = 8'd10;
            in2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Reset verification", test_num);
            in1 = 8'hFF;
            in2 = 8'hFF;
            op = 2'b00;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Max value addition (255 + 255)", test_num);
            in1 = 8'hFF;
            in2 = 8'hFF;
            op = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Subtraction result zero (128 - 128)", test_num);
            in1 = 8'd128;
            in2 = 8'd128;
            op = 2'b01;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 8'h00);
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
        input expected_cout;
        input [7:0] expected_out;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
        $dumpvars(0,clk, in1, in2, op, rst, cout, out);
    end

endmodule
