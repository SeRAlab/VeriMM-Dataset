`timescale 1ns/1ps

module fsm_moore_101_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg IN;
    reg RST;
    wire MATCH;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_moore_101 dut (
        .CLK(CLK),
        .IN(IN),
        .RST(RST),
        .MATCH(MATCH)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            IN = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Sequence 101");
            reset_dut();
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: No Match 111");
            reset_dut();
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overlapping 10101");
            reset_dut();
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 1;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Partial Sequence 100");
            reset_dut();
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reset during sequence 1-0-[RST]-1");
            reset_dut();
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) RST = 1;
            @(posedge CLK) begin
                RST = 0;
                IN = 1;
            end
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Sequence with leading zeros 00101");
            reset_dut();
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 1;
            @(posedge CLK) IN = 0;
            @(posedge CLK) IN = 1;
            @(posedge CLK); #1;
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
        $display("fsm_moore_101 Testbench");
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
        input expected_MATCH;
        begin
            if (expected_MATCH === (expected_MATCH ^ MATCH ^ expected_MATCH)) begin
                $display("PASS");
                $display("  Outputs: MATCH=%b",
                         MATCH);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MATCH=%b",
                         expected_MATCH);
                $display("  Got:      MATCH=%b",
                         MATCH);
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
        $dumpvars(0,CLK, IN, RST, MATCH);
    end

endmodule
