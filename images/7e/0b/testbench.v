`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Zero;
    reg clock;
    reg reset;
    reg start;
    wire Add_dec;
    wire Load_regs;
    wire Ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Zero(Zero),
        .clock(clock),
        .reset(reset),
        .start(start),
        .Add_dec(Add_dec),
        .Load_regs(Load_regs),
        .Ready(Ready)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            Zero = 0;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Assert start in S_Idle", test_num);
            reset_dut();
            start = 1;
            #2;

            #1;


            check_outputs(0, 1, 1);
            @(posedge clock);
            start = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify transition to S_Mul state", test_num);
            reset_dut();
            start = 1;
            @(posedge clock);
            #2 start = 0;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition S_Mul to S_Idle using Zero", test_num);
            reset_dut();

            start = 1;
            @(posedge clock);
            #2 start = 0;

            Zero = 1;
            @(posedge clock);
            #2 Zero = 0;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in S_Mul while Zero is low", test_num);
            reset_dut();
            start = 1;
            @(posedge clock);
            #2 start = 0;
            Zero = 0;
            repeat (3) @(posedge clock);
            #2;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple consecutive multiplication cycles", test_num);
            reset_dut();


            start = 1;
            @(posedge clock);
            #2 start = 0;
            Zero = 1;
            @(posedge clock);
            #2 Zero = 0;


            start = 1;
            @(posedge clock);
            #2 start = 0;
            Zero = 1;
            @(posedge clock);
            #2 Zero = 0;


            #1;



            check_outputs(0, 0, 1);
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
        input expected_Add_dec;
        input expected_Load_regs;
        input expected_Ready;
        begin
            if (expected_Add_dec === (expected_Add_dec ^ Add_dec ^ expected_Add_dec) &&
                expected_Load_regs === (expected_Load_regs ^ Load_regs ^ expected_Load_regs) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready)) begin
                $display("PASS");
                $display("  Outputs: Add_dec=%b, Load_regs=%b, Ready=%b",
                         Add_dec, Load_regs, Ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Add_dec=%b, Load_regs=%b, Ready=%b",
                         expected_Add_dec, expected_Load_regs, expected_Ready);
                $display("  Got:      Add_dec=%b, Load_regs=%b, Ready=%b",
                         Add_dec, Load_regs, Ready);
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
        $dumpvars(0,Zero, clock, reset, start, Add_dec, Load_regs, Ready);
    end

endmodule
