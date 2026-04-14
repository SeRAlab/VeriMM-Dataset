`timescale 1ns/1ps

module xor_and_tb;

    // Testbench signals (combinational circuit)
    reg c_in;
    reg d_in;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_and dut (
        .c_in(c_in),
        .d_in(d_in),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = 1;
            c_in = 1'b0;
            d_in = 1'b0;
            $display("Test %0d: c_in=0, d_in=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            c_in = 1'b0;
            d_in = 1'b1;
            $display("Test %0d: c_in=0, d_in=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            c_in = 1'b1;
            d_in = 1'b0;
            $display("Test %0d: c_in=1, d_in=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            c_in = 1'b1;
            d_in = 1'b1;
            $display("Test %0d: c_in=1, d_in=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_and Testbench");
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
        input expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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
