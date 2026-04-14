`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

    begin
        a = 4'sd0;
        b = 4'sd0;
        #1;

        check_outputs(7'sd0);
    end
        endtask

    task testcase002;

    begin
        a = 4'sd3;
        b = 4'sd4;
        #1;

        check_outputs(7'sd12);
    end
        endtask

    task testcase003;

    begin
        a = 4'sd5;
        b = -4'sd2;
        #1;

        check_outputs(-7'sd10);
    end
        endtask

    task testcase004;

    begin
        a = -4'sd4;
        b = 4'sd3;
        #1;

        check_outputs(-7'sd12);
    end
        endtask

    task testcase005;

    begin
        a = -4'sd2;
        b = -4'sd3;
        #1;

        check_outputs(7'sd6);
    end
        endtask

    task testcase006;

    begin
        a = 4'sd7;
        b = 4'sd1;
        #1;

        check_outputs(7'sd7);
    end
        endtask

    task testcase007;

    begin
        a = 4'sd7;
        b = 4'sd7;
        #1;

        check_outputs(7'sd49);
    end
        endtask

    task testcase008;

    begin
        a = -4'sd8;
        b = -4'sd8;
        #1;

        check_outputs(-7'sd64);
    end
        endtask

    task testcase009;

    begin
        a = -4'sd8;
        b = 4'sd7;
        #1;

        check_outputs(-7'sd56);
    end
        endtask

    task testcase010;

    begin
        a = -4'sd1;
        b = 4'sd1;
        #1;

        check_outputs(-7'sd1);
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
        input expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%b",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b",
                         expected_c);
                $display("  Got:      c=%b",
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
