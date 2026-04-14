`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg go;
    reg reset;
    wire done;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .go(go),
        .reset(reset),
        .done(done),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            go = 0;
            data = 8'h00;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 8'hFF;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            go = 1;
            data = 8'h00;
            @(posedge clk);
            go = 0;
            repeat (3) begin
                data = 8'h00;
                @(posedge clk);
            end


            if (done === 1'b1)
                $display("Path 0-0-0 reached a terminal state.");
            #1;

            check_outputs(done, match);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            go = 1;
            data = 8'h01;
            @(posedge clk);
            go = 0;
            repeat (3) begin
                data = 8'h01;
                @(posedge clk);
            end
            #1;

            check_outputs(done, match);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            go = 1;
            @(posedge clk);
            go = 0;
            data = 8'h01; @(posedge clk);
            data = 8'h00; @(posedge clk);
            data = 8'h01; @(posedge clk);
            repeat(2) @(posedge clk);
            #1;

            check_outputs(done, match);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            go = 1;
            @(posedge clk);
            go = 0;
            data = 8'h01; @(posedge clk);
            reset = 1;    @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_done;
        input expected_match;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: done=%b, match=%b",
                         done, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, match=%b",
                         expected_done, expected_match);
                $display("  Got:      done=%b, match=%b",
                         done, match);
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
        $dumpvars(0,clk, data, go, reset, done, match);
    end

endmodule
