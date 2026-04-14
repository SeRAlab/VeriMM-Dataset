`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire reset_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .reset_state(reset_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Asynchronous Reset Assertion", test_num);
        reset_dut();
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Synchronous Reset Release", test_num);
        reset_dut();


        @(negedge clk);
        rst_n = 1;


        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Stability of Active State", test_num);
        reset_dut();

        @(negedge clk);
        rst_n = 1;


        repeat(5) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Asynchronous Re-assertion Mid-cycle", test_num);
        reset_dut();


        @(negedge clk);
        rst_n = 1;
        @(posedge clk);
        #2;


        #5;
        rst_n = 0;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Rapid Reset Toggle", test_num);
        reset_dut();


        @(negedge clk);
        rst_n = 1;
        @(posedge clk);
        #2;


        #2 rst_n = 0;
        #2 rst_n = 1;



        @(posedge clk);
        #2;
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
        input expected_reset_state;
        begin
            if (expected_reset_state === (expected_reset_state ^ reset_state ^ expected_reset_state)) begin
                $display("PASS");
                $display("  Outputs: reset_state=%b",
                         reset_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_state=%b",
                         expected_reset_state);
                $display("  Got:      reset_state=%b",
                         reset_state);
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
        $dumpvars(0,clk, rst_n, reset_state);
    end

endmodule
