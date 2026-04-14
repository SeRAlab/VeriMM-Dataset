`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg rst;
    reg up;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .down(down),
        .rst(rst),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        up = 0;
        down = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Initialization", test_num);
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Counting Up to 5", test_num);
        reset_dut();
        repeat(5) begin
            up = 1;
            down = 0;
            @(posedge clk);
        end
        up = 0;
        #1 #1;
 check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Counting Down from 0 (Wrap-around)", test_num);
        reset_dut();
        repeat(2) begin
            up = 0;
            down = 1;
            @(posedge clk);
        end
        down = 0;
        #1 #1;
 check_outputs(4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Up Counting Wrap-around (16 pulses)", test_num);
        reset_dut();
        repeat(16) begin
            up = 1;
            down = 0;
            @(posedge clk);
        end
        up = 0;
        #1 #1;
 check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Increment and Decrement", test_num);
        reset_dut();

        repeat(10) begin
            up = 1; down = 0;
            @(posedge clk);
        end

        repeat(4) begin
            up = 0; down = 1;
            @(posedge clk);
        end
        up = 0;
        down = 0;
        #1 #1;
 check_outputs(4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No signals (Idle)", test_num);
        reset_dut();
        up = 0;
        down = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Priority", test_num);
        reset_dut();

        up = 1;
        down = 0;
        repeat(3) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        up = 0;
        #1 #1;
 check_outputs(4'h0);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, down, rst, up, count);
    end

endmodule
