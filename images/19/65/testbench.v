`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire reset_active;
    wire system_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .reset(reset),
        .reset_active(reset_active),
        .system_ready(system_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset Active State", test_num);
        reset_dut();

        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Transition to Normal State", test_num);
        reset_dut();
        reset = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Persistent Normal State", test_num);
        reset_dut();
        reset = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Re-assertion of Reset", test_num);
        reset_dut();
        reset = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Persistent Reset State", test_num);
        reset_dut();
        reset = 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_reset_active;
        input expected_system_ready;
        begin
            if (expected_reset_active === (expected_reset_active ^ reset_active ^ expected_reset_active) &&
                expected_system_ready === (expected_system_ready ^ system_ready ^ expected_system_ready)) begin
                $display("PASS");
                $display("  Outputs: reset_active=%b, system_ready=%b",
                         reset_active, system_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_active=%b, system_ready=%b",
                         expected_reset_active, expected_system_ready);
                $display("  Got:      reset_active=%b, system_ready=%b",
                         reset_active, system_ready);
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
        $dumpvars(0,clk, reset, reset_active, system_ready);
    end

endmodule
