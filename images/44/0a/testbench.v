`timescale 1ns/1ps

module shift_register_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data_in;
    reg load;
    reg reset_n;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_with_load dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        load = 0;
        data_in = 12'b0;
        @(negedge clk);
        reset_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase001: Reset Functionality");
        reset_dut();
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase002: Parallel Load 12'hA5A");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'hA5A;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(12'hA5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase003: Single Shift Right (002 -> 001)");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'h002;
        @(negedge clk);
        load = 0;
        @(negedge clk);
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase004: Shift Right to Zero (001 -> 000)");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'h001;
        @(negedge clk);
        load = 0;
        @(negedge clk);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Running testcase005: Multi-bit Shift Right (800 -> 001 in 11 shifts)");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'h800;
        @(negedge clk);
        load = 0;
        for (i = 0; i < 11; i = i + 1) begin
            @(negedge clk);
        end
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase006: Reset Priority over Load");
        reset_dut();
        @(negedge clk);
        reset_n = 0;
        load = 1;
        data_in = 12'hFFF;
        @(negedge clk);
        reset_n = 1;
        load = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running testcase007: All Ones Shift Right (FFF -> 7FF)");
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'hFFF;
        @(negedge clk);
        load = 0;
        @(negedge clk);
        #1;

        check_outputs(12'h7FF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_with_load Testbench");
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, reset_n, q);
    end

endmodule
