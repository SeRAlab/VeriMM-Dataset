`timescale 1ns/1ps

module one_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg xi;
    reg yi;
    wire Co;
    wire Si;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    one_bit_adder dut (
        .xi(xi),
        .yi(yi),
        .Co(Co),
        .Si(Si)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: xi=0, yi=0", test_num);
            xi = 0;
            yi = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: xi=0, yi=1", test_num);
            xi = 0;
            yi = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: xi=1, yi=0", test_num);
            xi = 1;
            yi = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: xi=1, yi=1", test_num);
            xi = 1;
            yi = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("one_bit_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_Co;
        input expected_Si;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_Si === (expected_Si ^ Si ^ expected_Si)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, Si=%b",
                         Co, Si);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, Si=%b",
                         expected_Co, expected_Si);
                $display("  Got:      Co=%b, Si=%b",
                         Co, Si);
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
