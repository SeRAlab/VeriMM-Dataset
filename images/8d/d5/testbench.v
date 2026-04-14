`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg nRST;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .nRST(nRST),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            nRST = 0;
            @(negedge CLK);
            nRST = 1;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Post-Reset Initial Bit (Index 15)", test_num);
            reset_dut();
            #1;

            check_outputs(TEST_PATTERN[15]);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Bit after 1 clock cycle (Index 14)", test_num);
            reset_dut();
            @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[14]);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Bit after 8 clock cycles (Index 7)", test_num);
            reset_dut();
            repeat(8) @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[7]);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Last bit of pattern (Index 0)", test_num);
            reset_dut();
            repeat(15) @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[0]);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: First wrap-around cycle (Index 15)", test_num);
            reset_dut();
            repeat(16) @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[15]);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Bit after 20 cycles (Index 11)", test_num);
            reset_dut();
            repeat(20) @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[11]);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Second wrap-around completion (Index 15)", test_num);
            reset_dut();
            repeat(32) @(posedge CLK);
            #2;
            #1;

            check_outputs(TEST_PATTERN[15]);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Mid-cycle reset verify", test_num);
            reset_dut();
            repeat(5) @(posedge CLK);
            reset_dut();
            #1;

            check_outputs(TEST_PATTERN[15]);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
        $dumpvars(0,CLK, nRST, OUT);
    end

endmodule
