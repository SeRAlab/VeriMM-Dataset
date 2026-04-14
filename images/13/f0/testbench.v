`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg nreset;
    wire stable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .nreset(nreset),
        .stable(stable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        nreset = 0;
        repeat(2) @(posedge clk);
        #1;
        nreset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Standard operation - Check stable after 5 cycles", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Premature check - Check stable after 3 cycles", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset interruption - Assert reset during countdown", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        nreset = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Recovery - Full cycle after an interrupted countdown", test_num);
        reset_dut();
        repeat(2) @(posedge clk);
        nreset = 0;
        repeat(2) @(posedge clk);
        nreset = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Persistence - Check if stable stays high after 10 cycles", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset after stability - Stable should drop immediately", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        @(posedge clk);
        nreset = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reset_controller Testbench");
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
        input expected_stable;
        begin
            if (expected_stable === (expected_stable ^ stable ^ expected_stable)) begin
                $display("PASS");
                $display("  Outputs: stable=%b",
                         stable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stable=%b",
                         expected_stable);
                $display("  Got:      stable=%b",
                         stable);
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
        $dumpvars(0,clk, nreset, stable);
    end

endmodule
