`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] d;
    wire [14:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        d = 11'h000;
        #1;

        check_outputs(15'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        d = 11'h7FF;
        #1;

        check_outputs(15'h7FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        d = 11'h001;
        #1;

        check_outputs(15'h0007);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        d = 11'h400;
        #1;

        check_outputs(15'h408B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        d = 11'h200;
        #1;

        check_outputs(15'h208A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        d = 11'h555;
        #1;

        check_outputs(15'h552D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        d = 11'h2AA;
        #1;

        check_outputs(15'h2AD2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        d = 11'h010;
        #1;

        check_outputs(15'h0181);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        d = 11'h008;
        #1;

        check_outputs(15'h004B);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        d = 11'h080;
        #1;

        check_outputs(15'h0888);
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
        input [14:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
