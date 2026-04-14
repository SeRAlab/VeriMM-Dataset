`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg Clear;
    wire Timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .Clear(Clear),
        .Timeout(Timeout)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            Clear = 1;
            @(posedge CLOCK);
            #1;
            Clear = 0;
            @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Immediate check after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Short count check (no timeout expected)", test_num);
            reset_dut();
            repeat (5) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Long count check (timeout expected)", test_num);
            reset_dut();

            repeat (256) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset after timeout check", test_num);
            reset_dut();

            repeat (256) @(posedge CLOCK);
            #1;
            if (Timeout === 1'b1) begin

                Clear = 1;
                @(posedge CLOCK);
                #1;
                #1;

                check_outputs(1'b0);
                Clear = 0;
            end else begin
                $display("Skipping sub-check: Timeout did not trigger.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Persistent Clear check", test_num);
            reset_dut();
            Clear = 1;
            repeat (50) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(1'b0);
            Clear = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_Timeout;
        begin
            if (expected_Timeout === (expected_Timeout ^ Timeout ^ expected_Timeout)) begin
                $display("PASS");
                $display("  Outputs: Timeout=%b",
                         Timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Timeout=%b",
                         expected_Timeout);
                $display("  Got:      Timeout=%b",
                         Timeout);
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
        $dumpvars(0,CLOCK, Clear, Timeout);
    end

endmodule
