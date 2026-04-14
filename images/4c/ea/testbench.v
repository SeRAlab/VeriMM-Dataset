`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg [1:0] z;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .z(z),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        z = 2'b00;
        k = 1'b0;
        $display("Test %0d: State P (00), k=0 -> Next z[1] should be 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        z = 2'b00;
        k = 1'b1;
        $display("Test %0d: State P (00), k=1 -> Next z[1] should be 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        z = 2'b01;
        k = 1'b0;
        $display("Test %0d: State Q (01), k=0 -> Next z[1] should be 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        z = 2'b01;
        k = 1'b1;
        $display("Test %0d: State Q (01), k=1 -> Next z[1] should be 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        z = 2'b10;
        k = 1'b0;
        $display("Test %0d: State R (10), k=0 -> Next z[1] should be 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        z = 2'b10;
        k = 1'b1;
        $display("Test %0d: State R (10), k=1 -> Next z[1] should be 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        z = 2'b11;
        k = 1'b0;
        $display("Test %0d: State S (11), k=0 -> Next z[1] should be 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        z = 2'b11;
        k = 1'b1;
        $display("Test %0d: State S (11), k=1 -> Next z[1] should be 1", test_num);
        #1;

        check_outputs(1'b1);
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
