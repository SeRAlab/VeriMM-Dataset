`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg valid;
    reg [3:0] x;
    wire [3:0] a;
    wire [3:0] d;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .x(x),
        .a(a),
        .d(d),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            x = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Transform (8, 4)", test_num);
            reset_dut();
            valid = 1; x = 4'd8; @(posedge clk); #1;
            valid = 1; x = 4'd4; @(posedge clk); #1;
            valid = 0;
            wait(done);
            #1;

            check_outputs(4'd6, 4'd2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Odd Sum/Difference (10, 3)", test_num);
            reset_dut();
            valid = 1; x = 4'd10; @(posedge clk); #1;
            valid = 1; x = 4'd3;  @(posedge clk); #1;
            valid = 0;
            wait(done);
            #1;

            check_outputs(4'd6, 4'd3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Values (15, 15)", test_num);
            reset_dut();
            valid = 1; x = 4'd15; @(posedge clk); #1;
            valid = 1; x = 4'd15; @(posedge clk); #1;
            valid = 0;
            wait(done);
            #1;

            check_outputs(4'd15, 4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Min Values (0, 0)", test_num);
            reset_dut();
            valid = 1; x = 4'd0; @(posedge clk); #1;
            valid = 1; x = 4'd0; @(posedge clk); #1;
            valid = 0;
            wait(done);
            #1;

            check_outputs(4'd0, 4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Detail (2, 6)", test_num);
            reset_dut();
            valid = 1; x = 4'd2; @(posedge clk); #1;
            valid = 1; x = 4'd6; @(posedge clk); #1;
            valid = 0;
            wait(done);
            #1;

            check_outputs(4'd4, 4'hE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [3:0] expected_a;
        input [3:0] expected_d;
        input expected_done;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: a=%h, d=%h, done=%b",
                         a, d, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, d=%h, done=%b",
                         expected_a, expected_d, expected_done);
                $display("  Got:      a=%h, d=%h, done=%b",
                         a, d, done);
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
        $dumpvars(0,clk, reset, valid, x, a, d, done);
    end

endmodule
