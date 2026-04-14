`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In32;
    wire [31:0] Out32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In32(In32),
        .Out32(Out32)
    );
    task testcase001;

    begin
        test_num = 1;
        In32 = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        In32 = 32'h00000001;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        In32 = 32'h00000002;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        In32 = 32'h3FFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        In32 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        In32 = 32'h80000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        In32 = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAA8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        In32 = 32'h55555555;
        #1;

        check_outputs(32'h55555554);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        In32 = 32'h12345678;
        #1;

        check_outputs(32'h48D159E0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        In32 = 32'hC0000000;
        #1;

        check_outputs(32'h00000000);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_Out32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out32 === (expected_Out32 ^ Out32 ^ expected_Out32)) begin
                $display("PASS");
                $display("  Outputs: Out32=%h",
                         Out32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out32=%h",
                         expected_Out32);
                $display("  Got:      Out32=%h",
                         Out32);
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
