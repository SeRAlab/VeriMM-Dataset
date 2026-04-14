`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg en;
    wire e;
    wire rs;
    wire rw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .e(e),
        .rs(rs),
        .rw(rw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en <= 0;
            d <= 8'h00;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Command Write (d[7:6]=00)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            d <= 8'b00110011;
            @(posedge clk);
            en <= 0;
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Data Write (d[7:6]=01)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            d <= 8'b01001111;
            @(posedge clk);
            en <= 0;
            #2;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Write (d[7:6]=10)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            d <= 8'b10101010;
            @(posedge clk);
            en <= 0;
            #2;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Write (d[7:6]=11)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            d <= 8'b11000000;
            @(posedge clk);
            en <= 0;
            #2;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Idle state (en=0)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 0;
            d <= 8'b00000000;
            @(posedge clk);
            #2;


            if (e === 0) begin
                $display("PASS");
                $display("  Outputs: e=%b", e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=0");
                $display("  Got:      e=%b", e);
                fail_count = fail_count + 1;
            end
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
        input expected_e;
        input expected_rs;
        input expected_rw;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_rs === (expected_rs ^ rs ^ expected_rs) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw)) begin
                $display("PASS");
                $display("  Outputs: e=%b, rs=%b, rw=%b",
                         e, rs, rw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%b, rs=%b, rw=%b",
                         expected_e, expected_rs, expected_rw);
                $display("  Got:      e=%b, rs=%b, rw=%b",
                         e, rs, rw);
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
        $dumpvars(0,clk, d, en, e, rs, rw);
    end

endmodule
