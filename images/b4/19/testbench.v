`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IN0;
    reg [31:0] IN1;
    reg SEL;
    wire [31:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .IN1(IN1),
        .SEL(SEL),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select IN0 (SEL=0)", test_num);
        IN0 = 32'hAAAA_AAAA;
        IN1 = 32'h5555_5555;
        SEL = 1'b0;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select IN1 (SEL=1)", test_num);
        IN0 = 32'hAAAA_AAAA;
        IN1 = 32'h5555_5555;
        SEL = 1'b1;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: All Zeros on IN0, SEL=0", test_num);
        IN0 = 32'h0000_0000;
        IN1 = 32'hFFFF_FFFF;
        SEL = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: All Ones on IN1, SEL=1", test_num);
        IN0 = 32'h0000_0000;
        IN1 = 32'hFFFF_FFFF;
        SEL = 1'b1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Mixed hex values, SEL=0", test_num);
        IN0 = 32'h1234_5678;
        IN1 = 32'h8765_4321;
        SEL = 1'b0;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mixed hex values, SEL=1", test_num);
        IN0 = 32'h1234_5678;
        IN1 = 32'h8765_4321;
        SEL = 1'b1;
        #1;

        check_outputs(32'h8765_4321);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Check IN0 with all bits toggled", test_num);
        IN0 = 32'hFFFF_FFFF;
        IN1 = 32'h0000_0000;
        SEL = 1'b0;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: High-frequency alternating pattern, SEL=1", test_num);
        IN0 = 32'h0F0F_0F0F;
        IN1 = 32'hF0F0_F0F0;
        SEL = 1'b1;
        #1;

        check_outputs(32'hF0F0_F0F0);
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
        input [31:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
