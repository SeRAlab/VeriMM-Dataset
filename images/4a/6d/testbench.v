`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IN0;
    reg [31:0] IN1;
    reg SEL;
    wire [31:0] MUX_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .IN1(IN1),
        .SEL(SEL),
        .MUX_OUT(MUX_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=0, IN0 pattern, IN1 pattern", test_num);
            IN0 = 32'hAAAA_AAAA;
            IN1 = 32'h5555_5555;
            SEL = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=1, IN0 pattern, IN1 pattern", test_num);
            IN0 = 32'hAAAA_AAAA;
            IN1 = 32'h5555_5555;
            SEL = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=0, All 1s vs All 0s", test_num);
            IN0 = 32'hFFFF_FFFF;
            IN1 = 32'h0000_0000;
            SEL = 1'b0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=1, All 1s vs All 0s", test_num);
            IN0 = 32'hFFFF_FFFF;
            IN1 = 32'h0000_0000;
            SEL = 1'b1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=0, Both inputs 0", test_num);
            IN0 = 32'h0000_0000;
            IN1 = 32'h0000_0000;
            SEL = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=1, Random patterns", test_num);
            IN0 = 32'h1234_5678;
            IN1 = 32'h9ABC_DEF0;
            SEL = 1'b1;
            #1;

            check_outputs(32'h9ABC_DEF0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SEL=0, Single bit pattern", test_num);
            IN0 = 32'h0000_0001;
            IN1 = 32'h8000_0000;
            SEL = 1'b0;
            #1;

            check_outputs(32'h0000_0001);
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
        input [31:0] expected_MUX_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MUX_OUT === (expected_MUX_OUT ^ MUX_OUT ^ expected_MUX_OUT)) begin
                $display("PASS");
                $display("  Outputs: MUX_OUT=%h",
                         MUX_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MUX_OUT=%h",
                         expected_MUX_OUT);
                $display("  Got:      MUX_OUT=%h",
                         MUX_OUT);
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
