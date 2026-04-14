`timescale 1ns/1ps

module clock_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire div_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_divider dut (
        .clk(clk),
        .enable(enable),
        .div_clk(div_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        repeat(10) @(posedge clk);
        #1;
        $display("Testcase %0d: Checking if div_clk remains low when enable=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        enable = 1;

        @(posedge clk);
        #1;
        $display("Testcase %0d: Checking if div_clk goes high on first rising edge", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        enable = 1;

        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Checking if div_clk completes a full cycle (returns to 0) after 2 input cycles", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        enable = 1;

        repeat(5) @(posedge clk);
        #1;
        $display("Testcase %0d: Checking output state after 5 clock cycles (should be high)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;
        $display("Testcase %0d: Checking if div_clk is forced low when enable is disabled", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        enable = 1;
        repeat(2) @(posedge clk);
        enable = 0;
        repeat(2) @(posedge clk);
        enable = 1;
        repeat(3) @(posedge clk);
        #1;
        $display("Testcase %0d: Checking recovery of clock division after disable/enable toggle", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_divider Testbench");
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
        input expected_div_clk;
        begin
            if (expected_div_clk === (expected_div_clk ^ div_clk ^ expected_div_clk)) begin
                $display("PASS");
                $display("  Outputs: div_clk=%b",
                         div_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: div_clk=%b",
                         expected_div_clk);
                $display("  Got:      div_clk=%b",
                         div_clk);
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
        $dumpvars(0,clk, enable, div_clk);
    end

endmodule
