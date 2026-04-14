`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        a = 0;
        b = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task run_test;

        input [7:0] val_a;
        input [7:0] val_b;
        input [15:0] expected;
        begin
            test_num = test_num + 1;
            a = val_a;
            b = val_b;
            @(negedge clk);
            $display("Test Case %0d: %d * %d", test_num, val_a, val_b);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        run_test(8'h00, 8'h00, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        run_test(8'hFF, 8'h00, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        run_test(8'hFF, 8'h01, 16'h00FF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        run_test(8'hFF, 8'hFF, 16'hFE01);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        run_test(8'd12, 8'd10, 16'd120);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        run_test(8'd16, 8'd16, 16'd256);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        run_test(8'd127, 8'd2, 16'd254);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        run_test(8'd13, 8'd17, 16'd221);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        run_test(8'd250, 8'd4, 16'd1000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        @(negedge clk);
        rst = 1;
        a = 8'hFF;
        b = 8'hFF;
        @(negedge clk);
        $display("Test Case %0d: Reset Behavior Check", test_num);
        #1;

        check_outputs(16'h0000);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input [15:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, rst, result);
    end

endmodule
