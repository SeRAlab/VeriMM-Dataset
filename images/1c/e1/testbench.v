`timescale 1ns/1ps

module SRAM_1bit_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RE;
    reg WE;
    wire Q;
    wire VLD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_1bit dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q),
        .VLD(VLD)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin
            WE = 1;
            D = 0;
            #10;
            WE = 0;
            D = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Writing 1 and Reading 1", test_num);
            WE = 1; D = 1;
            #10;
            WE = 0;
            wait(RE == 1); #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Writing 0 and Reading 0", test_num);

            WE = 1; D = 1; #10;

            WE = 1; D = 0; #10;
            WE = 0;
            wait(RE == 1); #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Data Retention when WE is low", test_num);

            WE = 1; D = 1; #10;

            WE = 0; D = 0; #10;
            wait(RE == 1); #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: VLD signal behavior when RE is low", test_num);
            WE = 1; D = 1; #10;
            WE = 0;
            wait(RE == 0); #2;



            #1;




            check_outputs(Q, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Successive Writes (1 then 0 then 1)", test_num);
            WE = 1; D = 1; #10;
            WE = 1; D = 0; #10;
            WE = 1; D = 1; #10;
            WE = 0;
            wait(RE == 1); #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Reading while simultaneously writing", test_num);
            WE = 1; D = 0; #10;
            WE = 1; D = 1;
            wait(RE == 1); #2;


            #1;



            check_outputs(1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_1bit Testbench");
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
        input expected_Q;
        input expected_VLD;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_VLD === (expected_VLD ^ VLD ^ expected_VLD)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, VLD=%b",
                         Q, VLD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, VLD=%b",
                         expected_Q, expected_VLD);
                $display("  Got:      Q=%b, VLD=%b",
                         Q, VLD);
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
        $dumpvars(0,D, RE, WE, Q, VLD);
    end

endmodule
