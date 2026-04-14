`timescale 1ns/1ps

module ring_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_3bit dut (
        .clk(clk),
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
        @(negedge clk);
        rst_n = 0;
        #10;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State Verification", test_num);
        reset_dut();







        rst_n = 0;
        #5;
        #1;

        check_outputs(3'b001);
        rst_n = 1;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Shift Left 1 Cycle", test_num);
        reset_dut();
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Shift Left 2 Cycles", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Wrap-around (3 Cycles)", test_num);
        reset_dut();
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Long Sequence (7 Cycles)", test_num);
        reset_dut();


        repeat(6) @(posedge clk);
        #1;









        #1;










        check_outputs(3'b010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_3bit Testbench");
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, rst_n, count);
    end

endmodule
