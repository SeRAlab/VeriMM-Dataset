`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rstn;
    reg up_down;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .en(en),
        .rstn(rstn),
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
            rstn = 0;
            en = 0;
            up_down = 0;
            @(negedge clk);
            rstn = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset and Initial State");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple Increment (0 to 1)");
            reset_dut();
            en = 1;
            up_down = 1;
            @(negedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simple Decrement (0 to 3)");
            reset_dut();
            en = 1;
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Increment Wrap Around (0->1->2->3->0)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Enable Signal (Disable at count 2)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Direction Toggle (0->1->2->1)");
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(2) @(negedge clk);
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Multiple Decrements (0->3->2)");
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_count;
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
        $dumpvars(0,clk, en, rstn, up_down, count);
    end

endmodule
