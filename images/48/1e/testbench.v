`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] AddressOffset;
    reg [31:0] OldAddress;
    wire [31:0] NewAddress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AddressOffset(AddressOffset),
        .OldAddress(OldAddress),
        .NewAddress(NewAddress)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition", test_num);
            OldAddress = 32'h0000_1000;
            AddressOffset = 32'h0000_0001;

            #1;


            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Larger offset", test_num);
            OldAddress = 32'h0000_2000;
            AddressOffset = 32'h0000_00FF;

            #1;


            check_outputs(32'h0000_23FC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero offset", test_num);
            OldAddress = 32'hABCD_EF01;
            AddressOffset = 32'h0000_0000;

            #1;


            check_outputs(32'hABCD_EF01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative offset (2's complement)", test_num);
            OldAddress = 32'h0000_1000;
            AddressOffset = 32'hFFFF_FFFF;


            #1;



            check_outputs(32'h0000_0FFC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addressing wrap around (Overflow)", test_num);
            OldAddress = 32'hFFFF_FFF0;
            AddressOffset = 32'h0000_0008;


            #1;



            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max offset shifting out", test_num);
            OldAddress = 32'h0000_0000;
            AddressOffset = 32'h4000_0000;


            #1;



            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Realistic Branch (Backwards)", test_num);
            OldAddress = 32'h0040_0008;
            AddressOffset = 32'hFFFF_FFFE;


            #1;



            check_outputs(32'h0040_0000);
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
        input [31:0] expected_NewAddress;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NewAddress === (expected_NewAddress ^ NewAddress ^ expected_NewAddress)) begin
                $display("PASS");
                $display("  Outputs: NewAddress=%h",
                         NewAddress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NewAddress=%h",
                         expected_NewAddress);
                $display("  Got:      NewAddress=%h",
                         NewAddress);
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
