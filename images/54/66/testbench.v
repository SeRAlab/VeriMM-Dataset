`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dly;
    reg done;
    reg req;
    reg rst_n;
    wire gnt;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dly(dly),
        .done(done),
        .req(req),
        .rst_n(rst_n),
        .gnt(gnt),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        dly = 0;
        done = 0;
        req = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        req = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, BBUSY);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        req = 1;
        @(posedge clk);
        done = 1;
        dly = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, BFREE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        req = 1;
        @(posedge clk);
        done = 1;
        dly = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, BWAIT);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk) req = 1;
        @(posedge clk) begin done = 1; dly = 1; end
        @(posedge clk) dly = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, BFREE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(posedge clk) req = 1;
        @(posedge clk) begin done = 1; dly = 0; end
        @(posedge clk) req = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        @(posedge clk) req = 1;
        @(posedge clk) begin done = 1; dly = 0; end
        @(posedge clk) req = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1, BBUSY);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        @(posedge clk) req = 1;
        @(posedge clk) done = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(1'b1, BBUSY);
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
        input expected_gnt;
        input [1:0] expected_state;
        begin
            if (expected_gnt === (expected_gnt ^ gnt ^ expected_gnt) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: gnt=%b, state=%h",
                         gnt, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt=%b, state=%h",
                         expected_gnt, expected_state);
                $display("  Got:      gnt=%b, state=%h",
                         gnt, state);
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
        $dumpvars(0,clk, dly, done, req, rst_n, gnt, state);
    end

endmodule
