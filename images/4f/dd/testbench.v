`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire done;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
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
        a = 0;
        b = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task wait_for_done;

        integer timeout;
        begin
            timeout = 0;
            while (!done && timeout < 50) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            if (timeout >= 50) $display("Error: Timeout waiting for done signal");
            #1;
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 0 x 0", test_num);
        a = 4'd0; b = 4'd0;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 1 x 1", test_num);
        a = 4'd1; b = 4'd1;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 15 x 15", test_num);
        a = 4'd15; b = 4'd15;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd225);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 15 x 0", test_num);
        a = 4'd15; b = 4'd0;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 3 x 7", test_num);
        a = 4'd3; b = 4'd7;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd21);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 12 x 4", test_num);
        a = 4'd12; b = 4'd4;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd48);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 8 x 2", test_num);
        a = 4'd8; b = 4'd2;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd16);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: 13 x 11", test_num);
        a = 4'd13; b = 4'd11;
        wait_for_done();
        #1;

        check_outputs(1'b1, 8'd143);
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
        input [7:0] expected_result;
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
        $dumpvars(0,a, b, clk, done, result);
    end

endmodule
