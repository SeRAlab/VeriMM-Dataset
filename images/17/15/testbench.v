`timescale 1ns/1ps

module timer_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] load_value;
    reg reset;
    reg start;
    wire [7:0] count;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_8bit dut (
        .clk(clk),
        .load_value(load_value),
        .reset(reset),
        .start(start),
        .count(count),
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
        start = 0;
        load_value = 8'h00;
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
        $display("Test %0d: Standard countdown from 5 to 0", test_num);
        reset_dut();
        load_value = 8'd5;

        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 1;

        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Countdown from 15 to 0", test_num);
        reset_dut();
        load_value = 8'd15;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 1;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify timer stays at zero after reaching it", test_num);
        reset_dut();
        load_value = 8'd3;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset during active countdown", test_num);
        reset_dut();
        load_value = 8'd20;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 1;
        repeat(5) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        #1;

        check_outputs(8'd20, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Timer remains idle when start is low", test_num);
        reset_dut();
        load_value = 8'd10;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum value countdown (255)", test_num);
        reset_dut();
        load_value = 8'hFF;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        start = 1;
        repeat(255) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_count;
        input expected_done;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: count=%h, done=%b",
                         count, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, done=%b",
                         expected_count, expected_done);
                $display("  Got:      count=%h, done=%b",
                         count, done);
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
        $dumpvars(0,clk, load_value, reset, start, count, done);
    end

endmodule
