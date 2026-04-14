`timescale 1ns/1ps

module door_lock_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg key;
    reg resetn;
    wire open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    door_lock dut (
        .clk(clk),
        .key(key),
        .resetn(resetn),
        .open(open)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        key = 0;
        @(posedge clk);
        #1;
        resetn = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset State (No Key)", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Successful Door Open", test_num);
        reset_dut();
        key = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Door Stays Closed Without Key", test_num);
        reset_dut();
        key = 0;
        repeat (3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Door Closes After Key Removal", test_num);
        reset_dut();
        key = 1;
        @(posedge clk);
        #1;
        key = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Reset While Open", test_num);
        reset_dut();
        key = 1;
        @(posedge clk);
        #1;

        resetn = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Key Glitch Test", test_num);
        reset_dut();
        key = 1;
        #2;
        key = 0;
        @(posedge clk);
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
        $display("door_lock Testbench");
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
        input expected_open;
        begin
            if (expected_open === (expected_open ^ open ^ expected_open)) begin
                $display("PASS");
                $display("  Outputs: open=%b",
                         open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: open=%b",
                         expected_open);
                $display("  Got:      open=%b",
                         open);
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
        $dumpvars(0,clk, key, resetn, open);
    end

endmodule
