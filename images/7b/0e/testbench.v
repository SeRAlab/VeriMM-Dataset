`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg RST;
    reg UP;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .RST(RST),
        .UP(UP),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            UP = 0;
            DOWN = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying increment (Up count to 3)...", test_num);
            reset_dut();
            UP = 1;
            DOWN = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying roll-over (7 to 0)...", test_num);
            reset_dut();
            UP = 1;
            DOWN = 0;
            repeat(8) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying decrement (5 to 4)...", test_num);
            reset_dut();

            UP = 1; DOWN = 0;
            repeat(5) @(posedge CLK);

            UP = 0; DOWN = 1;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying roll-under (0 to 7)...", test_num);
            reset_dut();
            UP = 0;
            DOWN = 1;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying idle state (UP=0, DOWN=0)...", test_num);
            reset_dut();
            UP = 1; DOWN = 0;
            repeat(2) @(posedge CLK);
            UP = 0; DOWN = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying conflicting signals (UP=1, DOWN=1)...", test_num);
            reset_dut();
            UP = 1; DOWN = 0;
            repeat(4) @(posedge CLK);
            UP = 1; DOWN = 1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, DOWN, RST, UP, Q);
    end

endmodule
