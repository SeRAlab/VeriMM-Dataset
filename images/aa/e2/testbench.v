`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    reg start;
    wire done;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        start = 0;
        a = 0;
        b = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task run_multiplier;

        input [7:0] val_a;
        input [7:0] val_b;
        begin
            a = val_a;
            b = val_b;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;



            fork
                begin
                    wait(done == 1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any


            @(posedge clk);
            #1;

            check_outputs(1'b1, val_a * val_b);
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 5 * 4", test_num);
        reset_dut();
        run_multiplier(8'd5, 8'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: 0 * 128", test_num);
        reset_dut();
        run_multiplier(8'd0, 8'd128);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: 255 * 0", test_num);
        reset_dut();
        run_multiplier(8'd255, 8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: 255 * 255", test_num);
        reset_dut();
        run_multiplier(8'hFF, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 1 * 123", test_num);
        reset_dut();
        run_multiplier(8'd1, 8'd123);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: 12 * 34", test_num);
        reset_dut();
        run_multiplier(8'd12, 8'd34);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: 16 * 16", test_num);
        reset_dut();
        run_multiplier(8'd16, 8'd16);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: 17 * 13", test_num);
        reset_dut();
        run_multiplier(8'd17, 8'd13);
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
        input expected_done;
        input [15:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,a, b, clk, rst_n, start, done, result);
    end

endmodule
