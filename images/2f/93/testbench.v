`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg mode;
    reg rst_n;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .mode(mode),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            mode = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic count up");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Rollover count up (16 cycles)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 0;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Basic count down (0 to 15)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 1;
            repeat (1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Count down 3 cycles");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Enable signal check (Disabled)");
            reset_dut();
            @(posedge clk);
            enable = 0;
            mode = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Toggle Mode during operation");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 0;
            repeat (5) @(posedge clk);
            mode = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Toggle Enable during operation");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 0;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Complex rollover down (18 cycles)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            mode = 1;
            repeat (18) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
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
        $dumpvars(0,clk, enable, mode, rst_n, count);
    end

endmodule
