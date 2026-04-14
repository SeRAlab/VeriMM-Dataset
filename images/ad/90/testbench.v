`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg LOAD;
    reg UP;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .LOAD(LOAD),
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
            LOAD = 1;
            UP = 0;
            DOWN = 0;
            @(posedge CLK);
            #1 LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset/Load verification", test_num);
            reset_dut();

            @(posedge CLK);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment check (0 to 5)", test_num);
            reset_dut();
            UP = 1;
            DOWN = 0;
            repeat(5) @(posedge CLK);
            #1 UP = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Decrement check (Reset to 0, count down to 14)", test_num);
            reset_dut();
            UP = 0;
            DOWN = 1;
            repeat(2) @(posedge CLK);
            #1 DOWN = 0;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold value check", test_num);
            reset_dut();
            UP = 1;
            repeat(3) @(posedge CLK);
            #1 UP = 0; DOWN = 0;
            repeat(3) @(posedge CLK);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Upward wraparound (15 to 0)", test_num);
            reset_dut();
            UP = 1;
            repeat(16) @(posedge CLK);
            #1 UP = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: LOAD priority over UP signal", test_num);
            reset_dut();
            UP = 1;
            repeat(4) @(posedge CLK);
            #1 LOAD = 1; UP = 1;
            @(posedge CLK);
            #1 LOAD = 0; UP = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Simultaneous UP and DOWN check", test_num);
            reset_dut();
            UP = 1;
            DOWN = 1;
            repeat(3) @(posedge CLK);
            #1 UP = 0; DOWN = 0;



            #1;




            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Complex sequence Up and Down", test_num);
            reset_dut();
            UP = 1; repeat(10) @(posedge CLK);
            #1 UP = 0; DOWN = 1; repeat(4) @(posedge CLK);
            #1 UP = 1; DOWN = 0; repeat(2) @(posedge CLK);
            #1 UP = 0; DOWN = 0;
            #1;

            check_outputs(4'h8);
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
        input [3:0] expected_Q;
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
        $dumpvars(0,CLK, DOWN, LOAD, UP, Q);
    end

endmodule
