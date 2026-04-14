`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [4:0] ring_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter dut (
        .clk(clk),
        .en(en),
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
        en = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset and Idle", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Rotate 1 step", test_num);
        reset_dut();
        en = 1;
        @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Rotate to MSB", test_num);
        reset_dut();
        en = 1;
        repeat(4) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full cycle wrap-around", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 12 rotation steps", test_num);
        reset_dut();
        en = 1;
        repeat(12) @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable toggling", test_num);
        reset_dut();
        en = 1;
        repeat(2) @(posedge clk);
        en = 0;
        repeat(2) @(posedge clk);
        en = 1;
        @(posedge clk);
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset mid-operation", test_num);
        reset_dut();
        en = 1;
        repeat(3) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        en = 0;
        @(posedge clk);
        #1;

        check_outputs(5'b00001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter Testbench");
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
        input [4:0] expected_ring_count;
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
        $dumpvars(0,clk, en, rst, ring_count);
    end

endmodule
