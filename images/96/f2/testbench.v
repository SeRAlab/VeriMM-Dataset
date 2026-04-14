`timescale 1ns/1ps

module fsm_moore_0011_tb;

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
    fsm_moore_0011 dut (
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
        @(posedge CLK);
    end
        endtask
    task drive_bit;

        input bit_val;
        begin
            @(negedge CLK);
            IN = bit_val;
        end
        endtask

    task testcase001;

    begin
        $display("Running Testcase 001: Standard sequence 0011");
        reset_dut();
        drive_bit(0);
        drive_bit(0);
        drive_bit(1);
        drive_bit(1);
        @(posedge CLK);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Continuous sequence 00110011");
        reset_dut();

        drive_bit(0); drive_bit(0); drive_bit(1); drive_bit(1);
        @(posedge CLK);

        drive_bit(0); drive_bit(0); drive_bit(1); drive_bit(1);
        @(posedge CLK);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Incorrect sequence 0010");
        reset_dut();
        drive_bit(0);
        drive_bit(0);
        drive_bit(1);
        drive_bit(0);
        @(posedge CLK);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Extra leading zeros 00011");
        reset_dut();
        drive_bit(0);
        drive_bit(0);
        drive_bit(0);
        drive_bit(1);
        drive_bit(1);
        @(posedge CLK);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Reset mid-sequence");
        reset_dut();
        drive_bit(0);
        drive_bit(0);
        drive_bit(1);

        @(negedge CLK) RST = 1;
        @(posedge CLK);
        #1 RST = 0;
        drive_bit(1);
        @(posedge CLK);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: All ones sequence");
        reset_dut();
        drive_bit(1);
        drive_bit(1);
        drive_bit(1);
        drive_bit(1);
        @(posedge CLK);
        #1 #1;
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
        $display("fsm_moore_0011 Testbench");
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
