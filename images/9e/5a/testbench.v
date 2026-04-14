`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ADDSUB;
    reg [26:0] D_DATA;
    reg INMODE2;
    reg [26:0] PREADD_AB;
    wire [26:0] AD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDSUB(ADDSUB),
        .D_DATA(D_DATA),
        .INMODE2(INMODE2),
        .PREADD_AB(PREADD_AB),
        .AD(AD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: INMODE2=0, ADDSUB=0 (0 + PREADD_AB)", test_num);
            INMODE2 = 1'b0;
            ADDSUB = 1'b0;
            D_DATA = 27'h5555555;
            PREADD_AB = 27'h1234567;
            #1;

            check_outputs(27'h1234567);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: INMODE2=0, ADDSUB=1 (0 - PREADD_AB)", test_num);
            INMODE2 = 1'b0;
            ADDSUB = 1'b1;
            D_DATA = 27'h0000000;
            PREADD_AB = 27'h0000001;

            #1;


            check_outputs(27'h7FFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: INMODE2=1, ADDSUB=0 (D_DATA + PREADD_AB)", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b0;
            D_DATA = 27'h1000000;
            PREADD_AB = 27'h2000000;
            #1;

            check_outputs(27'h3000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: INMODE2=1, ADDSUB=1 (D_DATA - PREADD_AB)", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b1;
            D_DATA = 27'h5000000;
            PREADD_AB = 27'h1000000;
            #1;

            check_outputs(27'h4000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Wrap-around", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b0;
            D_DATA = 27'h7FFFFFF;
            PREADD_AB = 27'h0000001;
            #1;

            check_outputs(27'h0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Resulting in negative value", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b1;
            D_DATA = 27'h0000005;
            PREADD_AB = 27'h000000A;
            #1;

            check_outputs(27'h7FFFFFB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b1;
            D_DATA = 27'h0000000;
            PREADD_AB = 27'h0000000;
            #1;

            check_outputs(27'h0000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: D_DATA - 0", test_num);
            INMODE2 = 1'b1;
            ADDSUB = 1'b1;
            D_DATA = 27'h3ABCDEF;
            PREADD_AB = 27'h0000000;
            #1;

            check_outputs(27'h3ABCDEF);
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
        input [26:0] expected_AD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AD === (expected_AD ^ AD ^ expected_AD)) begin
                $display("PASS");
                $display("  Outputs: AD=%h",
                         AD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AD=%h",
                         expected_AD);
                $display("  Got:      AD=%h",
                         AD);
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

endmodule
