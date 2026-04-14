`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg interrupt;
    reg [7:0] irIn;
    wire [7:0] OPout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .interrupt(interrupt),
        .irIn(irIn),
        .OPout(OPout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt LOW, Input 0x55", test_num);
            interrupt = 1'b0;
            irIn = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt LOW, Input 0xAA", test_num);
            interrupt = 1'b0;
            irIn = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt HIGH, Input 0xAA (Output should be 0)", test_num);
            interrupt = 1'b1;
            irIn = 8'hAA;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt HIGH, Input 0xFF (Output should be 0)", test_num);
            interrupt = 1'b1;
            irIn = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt LOW, Input 0xFF", test_num);
            interrupt = 1'b0;
            irIn = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt HIGH, Input 0x00", test_num);
            interrupt = 1'b1;
            irIn = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt LOW, Input 0x00", test_num);
            interrupt = 1'b0;
            irIn = 8'h00;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_OPout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OPout === (expected_OPout ^ OPout ^ expected_OPout)) begin
                $display("PASS");
                $display("  Outputs: OPout=%h",
                         OPout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OPout=%h",
                         expected_OPout);
                $display("  Got:      OPout=%h",
                         OPout);
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
