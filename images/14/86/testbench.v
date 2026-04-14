`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
    reg [15:0] x;
    wire [15:0] w0;
    wire [15:0] w1;
    wire [15:0] w2;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .x(x),
        .w0(w0),
        .w1(w1),
        .w2(w2),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Signals", test_num);
            reset_dut();
            x = 16'h0000;
            d = 16'h0000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Weight Adaptation (w0 focus)", test_num);
            reset_dut();


            x = 16'h4000;
            d = 16'h2000;

            @(posedge clk);
            @(posedge clk);



            if (w0 != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: w0 adapted to %h", w0);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: w0 remained zero");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Delay Line Propagation (w1, w2)", test_num);
            reset_dut();


            x = 16'h1000; d = 16'h1000;
            @(posedge clk);


            x = 16'h0000; d = 16'h0000;
            @(posedge clk);


            @(posedge clk);



            if (w1 != 16'h0000 && w2 != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: w1 and w2 adapted via delay line. w1=%h, w2=%h", w1, w2);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: w1 or w2 failed to adapt. w1=%h, w2=%h", w1, w2);
            end
        end
        endtask

    task testcase005;

        reg [15:0] prev_w0;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Convergence Test", test_num);
            reset_dut();

            x = 16'h2000;
            d = 16'h1000;


            repeat(20) @(posedge clk);

            prev_w0 = w0;
            @(posedge clk);



            if (w0 == prev_w0 || (w0 > prev_w0 ? w0-prev_w0 : prev_w0-w0) < 16'h0010) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter stabilized. w0=%h, y=%h", w0, y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter failing to converge. w0 changed from %h to %h", prev_w0, w0);
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
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_w0;
        input [15:0] expected_w1;
        input [15:0] expected_w2;
        input [15:0] expected_y;
        begin
            if (expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_w2 === (expected_w2 ^ w2 ^ expected_w2) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w0=%h, w1=%h, w2=%h, y=%h",
                         w0, w1, w2, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w0=%h, w1=%h, w2=%h, y=%h",
                         expected_w0, expected_w1, expected_w2, expected_y);
                $display("  Got:      w0=%h, w1=%h, w2=%h, y=%h",
                         w0, w1, w2, y);
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
        $dumpvars(0,clk, d, rst, x, w0, w1, w2, y);
    end

endmodule
