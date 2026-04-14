`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        up_down = 0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("Test %0d: Counting up 10 steps", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(negedge clk);
        end
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Test %0d: Counting down 5 steps from 0", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 0;
        for (i = 0; i < 5; i = i + 1) begin
            @(negedge clk);
        end
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Test %0d: Up 10 steps, Down 4 steps", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 1;
        for (i = 0; i < 10; i = i + 1) @(negedge clk);
        up_down = 0;
        for (i = 0; i < 4; i = i + 1) @(negedge clk);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Test %0d: Counter Overflow (FF to 00)", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 1;

        for (i = 0; i < 256; i = i + 1) @(negedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Test %0d: Counter Underflow (00 to FF)", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 0;
        @(negedge clk);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Reset Priority over Up Counting", test_num);
        reset_dut();
        @(negedge clk);
        up_down = 1;
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, up_down, q);
    end

endmodule
