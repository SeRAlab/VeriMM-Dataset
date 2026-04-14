`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg up;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
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
            reset = 1;
            enable = 0;
            up = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Up Counting");
            reset_dut();
            enable = 1;
            up = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Roll-under (Down from 0)");
            reset_dut();
            enable = 1;
            up = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Signal Check");
            reset_dut();
            up = 1;
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Direction Switching");
            reset_dut();
            enable = 1;
            up = 1;
            repeat(10) @(posedge clk);
            up = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd6);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Roll-over Check");
            reset_dut();
            enable = 1;
            up = 0;
            repeat(1) @(posedge clk);
            #1;
            up = 1;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple Decrements");
            reset_dut();
            enable = 1;
            up = 0;
            repeat(100) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFF9C);
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
        input [15:0] expected_count;
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
        $dumpvars(0,clk, enable, reset, up, count);
    end

endmodule
