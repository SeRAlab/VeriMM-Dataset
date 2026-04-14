`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg [15:0] dt;
    reg enable;
    reg rst;
    wire busy;
    wire [31:0] v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .dt(dt),
        .enable(enable),
        .rst(rst),
        .busy(busy),
        .v(v)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            dt = 0;
            enable = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Integration (10 * 5)", test_num);

            a = 16'd10;
            dt = 16'd5;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;


            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Accumulation (Step 1: 20*10, Step 2: 5*4)", test_num);


            a = 16'd20;
            dt = 16'd10;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);
            #1;


            a = 16'd5;
            dt = 16'd4;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'd220);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Integration", test_num);

            a = 16'd0;
            dt = 16'd100;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Large Values (500 * 500)", test_num);

            a = 16'd500;
            dt = 16'd500;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            wait(busy == 1);
            wait(busy == 0);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'd250000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verification of Reset clearing accumulator", test_num);


            a = 16'hFFFF;
            dt = 16'd2;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            wait(busy == 1);
            wait(busy == 0);


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'd0);
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
        input expected_busy;
        input [31:0] expected_v;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, v=%h",
                         busy, v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, v=%h",
                         expected_busy, expected_v);
                $display("  Got:      busy=%b, v=%h",
                         busy, v);
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
        $dumpvars(0,a, clk, dt, enable, rst, busy, v);
    end

endmodule
