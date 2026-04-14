`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .rst(rst),
        .q(q)
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
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset state check...");
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single clock cycle check...");
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: 8 clock cycles check...");
        reset_dut();
        repeat(8) @(negedge clk);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: 16 clock cycles (All Ones) check...");
        reset_dut();
        repeat(16) @(negedge clk);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: 17 clock cycles check...");
        reset_dut();
        repeat(17) @(negedge clk);
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: 24 clock cycles check...");
        reset_dut();
        repeat(24) @(negedge clk);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: 32 clock cycles (Full Period) check...");
        reset_dut();
        repeat(32) @(negedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: 33 clock cycles check...");
        reset_dut();
        repeat(33) @(negedge clk);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, rst, q);
    end

endmodule
