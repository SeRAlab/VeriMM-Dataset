`timescale 1ns/1ps

module Binary_counter_16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] limit;
    reg rst_n;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Binary_counter_16 dut (
        .clk(clk),
        .limit(limit),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            limit = 0;
            #10;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Count to 10");
            test_num = test_num + 1;
            reset_dut();
            limit = 16'd10;

            repeat (15) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Limit is 0");
            test_num = test_num + 1;
            reset_dut();
            limit = 16'd0;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Limit is 1");
            test_num = test_num + 1;
            reset_dut();
            limit = 16'd1;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Count to 255");
            test_num = test_num + 1;
            reset_dut();
            limit = 16'h00FF;
            repeat (260) @(posedge clk);
            #2;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mid-count Reset");
            test_num = test_num + 1;
            reset_dut();
            limit = 16'd50;
            repeat (25) @(posedge clk);


            rst_n = 0;
            #10;
            rst_n = 1;
            limit = 16'd20;

            repeat (30) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Binary_counter_16 Testbench");
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, limit, rst_n, Q);
    end

endmodule
