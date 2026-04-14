`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset_n;
    reg up;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .down(down),
        .reset_n(reset_n),
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
        reset_n = 0;
        up = 0;
        down = 0;
        #12;
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task wait_cycles;

        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

    begin
        $display("Testcase001: Reset Check");
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase002: Counting Up (10 cycles)");
        reset_dut();
        up = 1;
        down = 0;
        wait_cycles(10);
        up = 0;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase003: Counting Down (Underflow from 0)");
        reset_dut();
        up = 0;
        down = 1;
        wait_cycles(5);
        down = 0;
        #1;

        check_outputs(8'd251);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase004: Mixed Counting (Up 20, Down 5)");
        reset_dut();
        up = 1;
        wait_cycles(20);
        up = 0;
        down = 1;
        wait_cycles(5);
        down = 0;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase005: Overflow Wrap Around (Up 257 cycles)");
        reset_dut();
        up = 1;
        wait_cycles(257);
        up = 0;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase006: Simultaneous Up and Down");
        reset_dut();
        up = 1;
        down = 1;
        wait_cycles(10);
        up = 0;
        down = 0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase007: Hold value check");
        reset_dut();
        up = 1;
        wait_cycles(5);
        up = 0;
        down = 0;
        wait_cycles(5);
        #1;

        check_outputs(8'd5);
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, down, reset_n, up, count);
    end

endmodule
