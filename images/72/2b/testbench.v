`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    reg SCD;
    reg SCE;
    wire Q;
    wire Q_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .SCD(SCD),
        .SCE(SCE),
        .Q(Q),
        .Q_B(Q_B)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D = 0;
            SCD = 0;
            SCE = 0;
            RESET_B = 1;
            #2;
            RESET_B = 0;
            #10;
            RESET_B = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Asynchronous Set (SCD) Check", test_num);
            reset_dut();
            SCD = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
            SCD = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Synchronous Load D=1 (SCE=1)", test_num);
            reset_dut();
            D = 1;
            SCE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Synchronous Load D=0 (SCE=1)", test_num);
            reset_dut();

            D = 1; SCE = 1;
            @(posedge CLK);
            #2;

            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Clock Enable (SCE=0) Hold Check", test_num);
            reset_dut();

            D = 1; SCE = 1;
            @(posedge CLK);
            #2;

            SCE = 0;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: SCD Priority over Sync Controls", test_num);
            reset_dut();
            SCE = 1;
            D = 0;
            SCD = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            SCD = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: RESET_B Priority over Sync Controls", test_num);
            reset_dut();

            RESET_B = 0;
            SCE = 1;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            RESET_B = 1;
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
        input expected_Q;
        input expected_Q_B;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_B === (expected_Q_B ^ Q_B ^ expected_Q_B)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_B=%b",
                         Q, Q_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_B=%b",
                         expected_Q, expected_Q_B);
                $display("  Got:      Q=%b, Q_B=%b",
                         Q, Q_B);
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
        $dumpvars(0,CLK, D, RESET_B, SCD, SCE, Q, Q_B);
    end

endmodule
