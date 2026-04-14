`timescale 1ns/1ps

module verified_up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg up_down;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_up_down_counter dut (
        .clk(clk),
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
        up_down = 0;

        repeat(8) begin
            if (count === 3'b000) break;
            @(posedge clk);
        end

        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Increment 3 times (0 -> 3)", test_num);
        up_down = 1;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Decrement 1 time (0 -> 7)", test_num);
        up_down = 0;
        repeat(1) @(posedge clk);
        #2;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Increment 8 times (0 -> 0 roll-over)", test_num);
        up_down = 1;
        repeat(8) @(posedge clk);
        #2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Increment 5, then Decrement 2 (0 -> 5 -> 3)", test_num);
        up_down = 1;
        repeat(5) @(posedge clk);
        up_down = 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Decrement 2 times (0 -> 6)", test_num);
        up_down = 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(3'd6);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("verified_up_down_counter Testbench");
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, up_down, count);
    end

endmodule
