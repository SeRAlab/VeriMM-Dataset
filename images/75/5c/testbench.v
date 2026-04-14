`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] m;
    reg [15:0] n;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        m = 16'h0000;
        n = 16'h0000;
        $display("Test %0d: Addition of zeros", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        m = 16'h1234;
        n = 16'h4321;
        $display("Test %0d: Simple addition without carry", test_num);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        m = 16'hFFFF;
        n = 16'h0000;
        $display("Test %0d: Max value plus zero", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        m = 16'hFFFF;
        n = 16'h0001;
        $display("Test %0d: Addition with overflow/wrap-around (FFFF + 1)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        m = 16'h8000;
        n = 16'h8000;
        $display("Test %0d: MSB addition wrap-around", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        m = 16'hABCD;
        n = 16'h1234;
        $display("Test %0d: Mid-range addition", test_num);
        #1;

        check_outputs(16'hBFA1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        m = 16'hFFFF;
        n = 16'hFFFF;
        $display("Test %0d: Max value plus Max value wrap-around", test_num);
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        m = 16'h5555;
        n = 16'hAAAA;
        $display("Test %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
