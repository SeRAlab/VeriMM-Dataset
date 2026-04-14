`timescale 1ns/1ps

module ring_counter_6_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [5:0] ring_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_6 dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .ring_count(ring_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        @(posedge clk);
        #1;
        rst = 0;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking reset seed value...", test_num);
        reset_dut();

        #1;


        check_outputs(6'b000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking single left rotation...", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'b000010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking full 6-step cycle...", test_num);
        reset_dut();
        enable = 1;
        repeat(6) @(posedge clk);
        #1;

        #1;


        check_outputs(6'b000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking enable signal (hold value)...", test_num);
        reset_dut();
        enable = 1;
        repeat(2) @(posedge clk);
        enable = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(6'b000100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking 10-step rotation (wraparound + 4)...", test_num);
        reset_dut();
        enable = 1;
        repeat(10) @(posedge clk);
        #1;






        #1;







        check_outputs(6'b010000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking reset during operation...", test_num);
        reset_dut();
        enable = 1;
        repeat(4) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        #1;

        check_outputs(6'b000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_6 Testbench");
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
        input [5:0] expected_ring_count;
        begin
            if (expected_ring_count === (expected_ring_count ^ ring_count ^ expected_ring_count)) begin
                $display("PASS");
                $display("  Outputs: ring_count=%h",
                         ring_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring_count=%h",
                         expected_ring_count);
                $display("  Got:      ring_count=%h",
                         ring_count);
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
        $dumpvars(0,clk, enable, rst, ring_count);
    end

endmodule
