`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIN;
    reg LOAD;
    wire [3:0] Q;
    wire [3:0] QBAR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIN(DIN),
        .LOAD(LOAD),
        .Q(Q),
        .QBAR(QBAR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            DIN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Clear (LOAD=1, DIN=0)", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Preset (LOAD=1, DIN=1)", test_num);
            reset_dut();
            LOAD = 1;
            DIN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in sequence 1-0-1-0", test_num);
            reset_dut();
            LOAD = 0;

            DIN = 1; @(posedge CLK); #1;

            DIN = 0; @(posedge CLK); #1;

            DIN = 1; @(posedge CLK); #1;

            DIN = 0; @(posedge CLK); #1;
            #1;

            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in sequence 0-1-1-1", test_num);
            reset_dut();
            LOAD = 0;
            DIN = 0; @(posedge CLK); #1;
            DIN = 1; @(posedge CLK); #1;
            DIN = 1; @(posedge CLK); #1;
            DIN = 1; @(posedge CLK); #1;
            #1;

            check_outputs(4'b0111, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load all 1s then shift in a 0", test_num);
            reset_dut();

            LOAD = 1; DIN = 1; @(posedge CLK); #1;

            LOAD = 0; DIN = 0; @(posedge CLK); #1;
            #1;

            check_outputs(4'b1110, 4'b0001);
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
        input [3:0] expected_Q;
        input [3:0] expected_QBAR;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QBAR === (expected_QBAR ^ QBAR ^ expected_QBAR)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, QBAR=%h",
                         Q, QBAR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, QBAR=%h",
                         expected_Q, expected_QBAR);
                $display("  Got:      Q=%h, QBAR=%h",
                         Q, QBAR);
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
        $dumpvars(0,CLK, DIN, LOAD, Q, QBAR);
    end

endmodule
