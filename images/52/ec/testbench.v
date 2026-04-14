`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] In;
    wire [6:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Out(Out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'h0000000000000000", test_num);
        In = 64'h0000_0000_0000_0000;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'hFFFFFFFFFFFFFFFF", test_num);
        In = 64'hFFFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'h5555555555555555", test_num);
        In = 64'h5555_5555_5555_5555;
        #1;

        check_outputs(7'b1010101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'hAAAAAAAAAAAAAAAA", test_num);
        In = 64'hAAAA_AAAA_AAAA_AAAA;
        #1;

        check_outputs(7'b0101010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'h1234567890ABCDEF", test_num);
        In = 64'h1234_5678_90AB_CDEF;
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input with Don't Care Output", test_num);

        In = 64'hDEAD_BEEF_CAFE_BABE;

        #1;


        check_outputs(7'b1xx0xx1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'h0000000000000001", test_num);
        In = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(7'b0000001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 64'h8000000000000000", test_num);
        In = 64'h8000_0000_0000_0000;
        #1;

        check_outputs(7'b1000000);
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
        input [6:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
