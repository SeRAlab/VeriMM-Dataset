`timescale 1ns/1ps

module counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_3bit dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .q(q)
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
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Counting (3 increments)", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Enable/Disable Toggle", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        enable = 0;
        @(posedge clk);
        @(posedge clk);
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Full Wrap-around (8 pulses)", test_num);
        reset_dut();
        enable = 1;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reach Max Value (7)", test_num);
        reset_dut();
        enable = 1;
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_3bit Testbench");
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, enable, reset, q);
    end

endmodule
