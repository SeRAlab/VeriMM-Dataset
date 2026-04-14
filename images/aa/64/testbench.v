`timescale 1ns/1ps

module factorial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] n;
    reg reset;
    reg start;
    wire done;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    factorial dut (
        .clk(clk),
        .n(n),
        .reset(reset),
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
            reset = 1;
            start = 0;
            n = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 0!", test_num);
            reset_dut();
            n = 4'd0;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 1!", test_num);
            reset_dut();
            n = 4'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 3!", test_num);
            reset_dut();
            n = 4'd3;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 5!", test_num);
            reset_dut();
            n = 4'd5;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 8!", test_num);
            reset_dut();
            n = 4'd8;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd40320);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 10!", test_num);
            reset_dut();
            n = 4'd10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd3628800);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Calculate 12! (Max 32-bit safely)", test_num);
            reset_dut();
            n = 4'd12;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            while (!done) @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'd479001600);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("factorial Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_result;
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
        $dumpvars(0,clk, n, reset, start, done, result);
    end

endmodule
