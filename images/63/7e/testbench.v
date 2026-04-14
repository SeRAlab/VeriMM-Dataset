`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg up_down;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .resetn(resetn),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        resetn = 0;
        up_down = 1;
        @(negedge clk);
        resetn = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Reset Check", test_num);
        reset_dut();


        #1;



        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Up Counting (10 cycles)", test_num);
        reset_dut();
        up_down = 1;
        repeat(10) @(negedge clk);
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Down Counting / Underflow Wrap", test_num);
        reset_dut();
        up_down = 0;
        repeat(1) @(negedge clk);
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Direction Switch (Up 15, Down 5)", test_num);
        reset_dut();
        up_down = 1;
        repeat(15) @(negedge clk);
        up_down = 0;
        repeat(5) @(negedge clk);
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Direction Switch (Down 10, Up 20)", test_num);
        reset_dut();
        up_down = 0;
        repeat(10) @(negedge clk);
        up_down = 1;
        repeat(20) @(negedge clk);
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Up Count", test_num);
        reset_dut();
        up_down = 1;
        repeat(1000) @(negedge clk);
        #1;

        check_outputs(12'd1000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset during active counting", test_num);
        reset_dut();
        up_down = 1;
        repeat(50) @(negedge clk);

        @(negedge clk);
        resetn = 0;
        @(negedge clk);
        resetn = 1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Down Wraps (4096 + 5 steps)", test_num);
        reset_dut();
        up_down = 0;
        repeat(4101) @(negedge clk);
        #1;

        check_outputs(12'hFFB);
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
        testcase008();
        
        
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
        input [11:0] expected_count;
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
        $dumpvars(0,clk, resetn, up_down, count);
    end

endmodule
