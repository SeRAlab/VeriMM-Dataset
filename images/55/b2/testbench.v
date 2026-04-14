`timescale 1ns/1ps

module counter_2bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    wire [1:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_2bit dut (
        .CLK(CLK),
        .RESET(RESET),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RESET = 1;
            @(negedge CLK);
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Increment to 1", test_num);
            reset_dut();
            @(negedge CLK);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Count to 3", test_num);
            reset_dut();
            repeat(3) @(negedge CLK);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Rollover check", test_num);
            reset_dut();
            repeat(4) @(negedge CLK);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mid-count synchronous reset", test_num);
            reset_dut();
            repeat(2) @(negedge CLK);
            @(negedge CLK);
            RESET = 1;
            @(negedge CLK);
            RESET = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple rollovers (9 cycles)", test_num);
            reset_dut();
            repeat(9) @(negedge CLK);
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_2bit Testbench");
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
        input [1:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, RESET, COUNT);
    end

endmodule
