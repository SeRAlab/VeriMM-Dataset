`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg D;
    reg H;
    reg SI;
    reg SM;
    wire Q;
    wire SO;
    wire XQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .D(D),
        .H(H),
        .SI(SI),
        .SM(SM),
        .Q(Q),
        .SO(SO),
        .XQ(XQ)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            SM = 0;
            H = 0;
            D = 0;
            SI = 0;
            @(posedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Normal Load D=1 (SM=0, H=0)", test_num);
            D = 1; H = 0; SM = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Normal Load D=0 (SM=0, H=0)", test_num);

            D = 1; H = 0; SM = 0;
            @(posedge CK);
            #1;
            D = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Hold 1 (SM=0, H=1)", test_num);
            D = 1; H = 0; SM = 0;
            @(posedge CK);
            #1;
            H = 1; D = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Hold 0 (SM=0, H=1)", test_num);
            D = 0; H = 0; SM = 0;
            @(posedge CK);
            #1;
            H = 1; D = 1;
            @(posedge CK);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Scan Mode SI=1 (SM=1)", test_num);
            SM = 1; SI = 1; D = 0; H = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Scan Mode SI=0 (SM=1)", test_num);

            D = 1; H = 0; SM = 0;
            @(posedge CK);
            #1;
            SM = 1; SI = 0; D = 1;
            @(posedge CK);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Scan Mode Priority over Hold", test_num);

            D = 0; H = 0; SM = 0;
            @(posedge CK);
            #1;

            SM = 1; SI = 1; H = 1; D = 0;
            @(posedge CK);
            #1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Scan Mode Priority over Data", test_num);
            SM = 1; SI = 0; D = 1; H = 0;
            @(posedge CK);
            #1;
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
        input expected_Q;
        input expected_SO;
        input expected_XQ;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_SO === (expected_SO ^ SO ^ expected_SO) &&
                expected_XQ === (expected_XQ ^ XQ ^ expected_XQ)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, SO=%b, XQ=%b",
                         Q, SO, XQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, SO=%b, XQ=%b",
                         expected_Q, expected_SO, expected_XQ);
                $display("  Got:      Q=%b, SO=%b, XQ=%b",
                         Q, SO, XQ);
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
        $dumpvars(0,CK, D, H, SI, SM, Q, SO, XQ);
    end

endmodule
