`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
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
        .reset(reset),
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
            reset = 1;
            x = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: DC Convergence (Single Tap)", test_num);
            reset_dut();

            x = 16'h0001;
            d = 16'h0005;



            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(16'h0005, 16'h0000, 16'h0000, 16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Delayed Signal Convergence", test_num);
            reset_dut();


            x = 16'h0002; d = 16'h0000; @(posedge clk); #1;


            x = 16'h0000; d = 16'h000A; @(posedge clk); #1;


            repeat(5) @(posedge clk);
            #1;




            if (w1 > 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter adapted w1 for delayed signal. w1=%h", w1);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: w1 did not adapt. w1=%h", w1);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Zero Input Response", test_num);
            reset_dut();

            x = 16'h0000;
            d = 16'hFFFF;

            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
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
        $dumpvars(0,clk, d, reset, x, w0, w1, w2, y);
    end

endmodule
