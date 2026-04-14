`timescale 1ns/1ps

module up_down_counter_6_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg rst;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_6 dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
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
        direction = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset verification", test_num);
        reset_dut();

        #1;


        check_outputs(6'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Up Counting (10 cycles)", test_num);
        reset_dut();
        direction = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(6'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Down Counting (5 cycles)", test_num);
        reset_dut();
        direction = 1;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(6'd59);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow (Count Up to 65)", test_num);
        reset_dut();
        direction = 0;
        repeat(65) @(posedge clk);
        #1;

        #1;


        check_outputs(6'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Underflow (Count Down from 0)", test_num);
        reset_dut();
        direction = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(6'h3F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Direction Toggle (Up 20, Down 5)", test_num);
        reset_dut();
        direction = 0;
        repeat(20) @(posedge clk);
        direction = 1;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(6'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Transition (Count to 63 then 64)", test_num);
        reset_dut();
        direction = 0;
        repeat(63) @(posedge clk);
        #1;
        if (count !== 6'd63) $display("Error at boundary 63");
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_6 Testbench");
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, direction, rst, count);
    end

endmodule
