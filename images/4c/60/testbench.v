`timescale 1ns/1ps

module fsm_mealy_010_tb;

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
    fsm_mealy_010 dut (
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
            #2 RST = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task apply_bit;

        input bit_val;
        begin
            @(negedge CLK);
            IN = bit_val;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic sequence 010", test_num);
            reset_dut();
            apply_bit(0);
            apply_bit(1);
            apply_bit(0);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overlapping sequence 01010", test_num);
            reset_dut();
            apply_bit(0);
            apply_bit(1);
            apply_bit(0);
            apply_bit(1);
            apply_bit(0);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incorrect sequence 011", test_num);
            reset_dut();
            apply_bit(0);
            apply_bit(1);
            apply_bit(1);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple leading zeros 00010", test_num);
            reset_dut();
            apply_bit(0);
            apply_bit(0);
            apply_bit(0);
            apply_bit(1);
            apply_bit(0);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All ones 111", test_num);
            reset_dut();
            apply_bit(1);
            apply_bit(1);
            apply_bit(1);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset mid-sequence 01-(RST)-0", test_num);
            reset_dut();
            apply_bit(0);
            apply_bit(1);

            @(negedge CLK);
            RST = 1;
            @(posedge CLK);
            #1 RST = 0;
            apply_bit(0);
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
        $display("fsm_mealy_010 Testbench");
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
