`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg din;
    reg wrenb;
    wire dout;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .wrenb(wrenb),
        .dout(dout),
        .hit(hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            wrenb = 1;
            din = 0;
            addr = 0;
            repeat (16) @(posedge clk);
            wrenb = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            wrenb = 1;
            din = 1;
            repeat (16) @(posedge clk);
            wrenb = 0;
            addr = 4'd0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = 2;
            reset_dut();
            pattern = 16'b1011_0000_1111_0101;
            wrenb = 1;
            for (i = 15; i >= 0; i = i - 1) begin
                din = pattern[i];
                @(posedge clk);
            end
            wrenb = 0;
            addr = 4'd1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            wrenb = 1;
            din = 1;
            @(posedge clk);
            wrenb = 0;
            addr = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            wrenb = 1;
            din = 1;
            @(posedge clk);
            wrenb = 0;
            din = 0;
            repeat (5) @(posedge clk);
            addr = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            wrenb = 1;
            din = 1;
            @(posedge clk);
            din = 0;
            repeat (15) @(posedge clk);
            wrenb = 0;
            addr = 4'd15;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_dout;
        input expected_hit;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: dout=%b, hit=%b",
                         dout, hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b, hit=%b",
                         expected_dout, expected_hit);
                $display("  Got:      dout=%b, hit=%b",
                         dout, hit);
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
        $dumpvars(0,addr, clk, din, wrenb, dout, hit);
    end

endmodule
