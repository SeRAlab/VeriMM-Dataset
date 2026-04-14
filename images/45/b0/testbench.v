`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up_down;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            up_down = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Up Counting");
            reset_dut();
            up_down = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Down Counting Wrap-around (0 to 255)");
            reset_dut();
            up_down = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd251);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Direction Switching");
            reset_dut();
            up_down = 1;
            repeat (20) @(posedge clk);
            up_down = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Up Counting Wrap-around (255 to 0)");
            reset_dut();
            up_down = 1;
            repeat (257) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mid-count Synchronous Reset");
            reset_dut();
            up_down = 1;
            repeat (15) @(posedge clk);
            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
            @(negedge clk);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Held Reset");
            reset_dut();
            rst = 1;
            up_down = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
            @(negedge clk);
            rst = 0;
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
        $dumpvars(0,clk, rst, up_down, count);
    end

endmodule
