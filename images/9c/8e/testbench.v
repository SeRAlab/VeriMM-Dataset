`timescale 1ns/1ps

module reset_sequential_module_with_rst_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rst;
    wire s;
    wire t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_sequential_module_with_rst dut (
        .clock(clock),
        .rst(rst),
        .s(s),
        .t(t)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 0;

            @(negedge clock);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rst = 1;
            @(posedge clock);
            #5;
            $display("Testcase %0d: After 1st edge", test_num);
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            rst = 1;
            repeat(2) @(posedge clock);
            #5;
            $display("Testcase %0d: After 2nd edge", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rst = 1;
            repeat(3) @(posedge clock);
            #5;
            $display("Testcase %0d: After 3rd edge", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            rst = 1;
            repeat(4) @(posedge clock);
            #5;
            $display("Testcase %0d: After 4th edge", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rst = 1;
            repeat(5) @(posedge clock);
            #5;
            $display("Testcase %0d: After 5th edge", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            rst = 1;
            repeat(6) @(posedge clock);
            #5;
            $display("Testcase %0d: After 6th edge", test_num);
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
        $display("reset_sequential_module_with_rst Testbench");
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
        input expected_s;
        input expected_t;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s) &&
                expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: s=%b, t=%b",
                         s, t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%b, t=%b",
                         expected_s, expected_t);
                $display("  Got:      s=%b, t=%b",
                         s, t);
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
        $dumpvars(0,clock, rst, s, t);
    end

endmodule
