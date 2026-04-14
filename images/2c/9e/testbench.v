`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Basic Addition (10 + 20)", test_num);
            reset_dut();

            @(posedge clk);
            a = 8'd10;
            b = 8'd20;
            start = 1;

            @(posedge clk);
            start = 0;


            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Max Value Overflow (255 + 1)", test_num);
            reset_dut();

            @(posedge clk);
            a = 8'hFF;
            b = 8'h01;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Boundary Addition (127 + 128)", test_num);
            reset_dut();

            @(posedge clk);
            a = 8'd127;
            b = 8'd128;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Zero Addition (0 + 0)", test_num);
            reset_dut();

            @(posedge clk);
            a = 8'd0;
            b = 8'd0;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Large Numbers (200 + 100)", test_num);
            reset_dut();

            @(posedge clk);
            a = 8'd200;
            b = 8'd100;
            start = 1;

            @(posedge clk);
            start = 0;

            repeat(6) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
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
        input [7:0] expected_sum;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: done=%b, sum=%h",
                         done, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, sum=%h",
                         expected_done, expected_sum);
                $display("  Got:      done=%b, sum=%h",
                         done, sum);
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
        $dumpvars(0,a, b, clk, reset, start, done, sum);
    end

endmodule
