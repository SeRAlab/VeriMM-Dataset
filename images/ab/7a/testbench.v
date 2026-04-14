`timescale 1ns/1ps

module logic_system_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg h;
    reg i;
    reg j;
    wire k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_system dut (
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .k(k)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: g=1, h=0, i=1, j=0");
        g = 1; h = 0; i = 1; j = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: g=0, h=1, i=1, j=0");
        g = 0; h = 1; i = 1; j = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: g=1, h=1, i=0, j=1");
        g = 1; h = 1; i = 0; j = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: g=0, h=0, i=0, j=1");
        g = 0; h = 0; i = 0; j = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: g=1, h=1, i=1, j=1");
        g = 1; h = 1; i = 1; j = 1;
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
        $display("logic_system Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: k=%b",
                         k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%b",
                         expected_k);
                $display("  Got:      k=%b",
                         k);
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
