`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Nothing;
    reg Q0;
    reg Zero;
    reg clock;
    reg reset;
    reg start;
    wire Add_regs;
    wire Decr_P;
    wire Load_regs;
    wire Ready;
    wire Shift_regs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Nothing(Nothing),
        .Q0(Q0),
        .Zero(Zero),
        .clock(clock),
        .reset(reset),
        .start(start),
        .Add_regs(Add_regs),
        .Decr_P(Decr_P),
        .Load_regs(Load_regs),
        .Ready(Ready),
        .Shift_regs(Shift_regs)
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
            Nothing = 0;
            Zero = 0;
            Q0 = 0;
            #10;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying IDLE state outputs", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying LOAD state outputs", test_num);
            reset_dut();
            start = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying ADD state with Q0=1 (Add_regs should be high)", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            start = 0;
            Q0 = 1;
            @(posedge clock); #2;
            #1;

            check_outputs(1, 1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying ADD state with Q0=0 (Add_regs should be low)", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            start = 0;
            Q0 = 0;
            @(posedge clock); #2;
            #1;

            check_outputs(0, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying SHIFT state outputs", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            @(posedge clock); #2;
            #1;

            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Completing operation via Zero=1", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            Zero = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            #1;

            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Completing operation via Nothing=1 (Zero=0)", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            Zero = 0; Nothing = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            #1;

            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Verifying loop from SHIFT back to ADD (Zero=0, Nothing=0)", test_num);
            reset_dut();
            start = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            Zero = 0; Nothing = 0; Q0 = 1;
            @(posedge clock); #2;
            @(posedge clock); #2;
            #1;

            check_outputs(1, 1, 0, 0, 0);
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
        input expected_Add_regs;
        input expected_Decr_P;
        input expected_Load_regs;
        input expected_Ready;
        input expected_Shift_regs;
        begin
            if (expected_Add_regs === (expected_Add_regs ^ Add_regs ^ expected_Add_regs) &&
                expected_Decr_P === (expected_Decr_P ^ Decr_P ^ expected_Decr_P) &&
                expected_Load_regs === (expected_Load_regs ^ Load_regs ^ expected_Load_regs) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready) &&
                expected_Shift_regs === (expected_Shift_regs ^ Shift_regs ^ expected_Shift_regs)) begin
                $display("PASS");
                $display("  Outputs: Add_regs=%b, Decr_P=%b, Load_regs=%b, Ready=%b, Shift_regs=%b",
                         Add_regs, Decr_P, Load_regs, Ready, Shift_regs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Add_regs=%b, Decr_P=%b, Load_regs=%b, Ready=%b, Shift_regs=%b",
                         expected_Add_regs, expected_Decr_P, expected_Load_regs, expected_Ready, expected_Shift_regs);
                $display("  Got:      Add_regs=%b, Decr_P=%b, Load_regs=%b, Ready=%b, Shift_regs=%b",
                         Add_regs, Decr_P, Load_regs, Ready, Shift_regs);
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
        $dumpvars(0,Nothing, Q0, Zero, clock, reset, start, Add_regs, Decr_P, Load_regs, Ready, Shift_regs);
    end

endmodule
