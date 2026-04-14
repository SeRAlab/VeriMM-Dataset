`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .reset_n(reset_n),
        .reset_out(reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Idle state check (reset_n=1)", test_num);
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Initial reset_out assertion", test_num);
        reset_n = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Mid-sequence duration check (5 cycles)", test_num);
        reset_n = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: End-of-sequence boundary check (10 cycles)", test_num);
        reset_n = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Return to low check (11th cycle)", test_num);
        reset_n = 0;
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Extended reset_n low (held for 20 cycles)", test_num);
        reset_n = 0;
        repeat(20) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Re-triggering sequence", test_num);

        reset_n = 0;
        @(posedge clk);
        reset_n = 1;
        repeat(12) @(posedge clk);

        reset_n = 0;
        @(posedge clk);
        #1;
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
        $display("reset_controller Testbench");
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
        input expected_reset_out;
        begin
            if (expected_reset_out === (expected_reset_out ^ reset_out ^ expected_reset_out)) begin
                $display("PASS");
                $display("  Outputs: reset_out=%b",
                         reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_out=%b",
                         expected_reset_out);
                $display("  Got:      reset_out=%b",
                         reset_out);
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
        $dumpvars(0,clk, reset_n, reset_out);
    end

endmodule
