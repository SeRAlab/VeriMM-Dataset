`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] din0;
    reg [15:0] din1;
    reg sel0;
    reg sel1;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .sel0(sel0),
        .sel1(sel1),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din0 (Normal data)", test_num);
            din0 = 16'h1234;
            din1 = 16'hABCD;
            sel0 = 1;
            sel1 = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din1 (Normal data)", test_num);
            din0 = 16'h1234;
            din1 = 16'hABCD;
            sel0 = 0;
            sel1 = 1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din0 (All ones)", test_num);
            din0 = 16'hFFFF;
            din1 = 16'h0000;
            sel0 = 1;
            sel1 = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din1 (All ones)", test_num);
            din0 = 16'h0000;
            din1 = 16'hFFFF;
            sel0 = 0;
            sel1 = 1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din0 (Alternating bits)", test_num);
            din0 = 16'hAAAA;
            din1 = 16'h5555;
            sel0 = 1;
            sel1 = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select din1 (Alternating bits)", test_num);
            din0 = 16'hAAAA;
            din1 = 16'h5555;
            sel0 = 0;
            sel1 = 1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data swap - Select din0", test_num);
            din0 = 16'hF0F0;
            din1 = 16'h0F0F;
            sel0 = 1;
            sel1 = 0;
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data swap - Select din1", test_num);
            din0 = 16'hF0F0;
            din1 = 16'h0F0F;
            sel0 = 0;
            sel1 = 1;
            #1;

            check_outputs(16'h0F0F);
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
        input [15:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
