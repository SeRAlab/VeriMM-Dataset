`timescale 1ns/1ps

module binary_counter_6bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg ENABLE;
    reg RESET;
    wire [5:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_6bit dut (
        .CLK(CLK),
        .ENABLE(ENABLE),
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
            RESET = 1;
            ENABLE = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 5 times", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify counter pauses when ENABLE is low", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(3) @(posedge CLK);
            ENABLE = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(6'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify rollover (63 -> 0)", test_num);
            reset_dut();
            ENABLE = 1;
            repeat(64) @(posedge CLK);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent ENABLE pulses", test_num);
            reset_dut();
            ENABLE = 1; @(posedge CLK);
            ENABLE = 0; @(posedge CLK);
            ENABLE = 1; @(posedge CLK);
            ENABLE = 1; @(posedge CLK);
            ENABLE = 0; @(posedge CLK);
            #1;
            #1;

            check_outputs(6'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_6bit Testbench");
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
        input [5:0] expected_COUNT;
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
        $dumpvars(0,CLK, ENABLE, RESET, COUNT);
    end

endmodule
