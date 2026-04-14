`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] num_in;
    wire [63:0] num_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num_in(num_in),
        .num_out(num_out)
    );
    task testcase001;

    begin
        test_num = 1;
        num_in = 16'h0000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        num_in = 16'h0001;
        #1;

        check_outputs(64'h0000000000000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        num_in = 16'h7FFF;
        #1;

        check_outputs(64'h0000000000007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        num_in = 16'hFFFF;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        num_in = 16'h8000;
        #1;

        check_outputs(64'hFFFFFFFFFFFF8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        num_in = 16'h1234;
        #1;

        check_outputs(64'h0000000000001234);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        num_in = 16'hA5A5;
        #1;

        check_outputs(64'hFFFFFFFFFFFFA5A5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        num_in = 16'h5555;
        #1;

        check_outputs(64'h0000000000005555);
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
        input [63:0] expected_num_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num_out === (expected_num_out ^ num_out ^ expected_num_out)) begin
                $display("PASS");
                $display("  Outputs: num_out=%h",
                         num_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_out=%h",
                         expected_num_out);
                $display("  Got:      num_out=%h",
                         num_out);
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
