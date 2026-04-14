`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bus_in;
    wire bus_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_in(bus_in),
        .bus_out(bus_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Drive bus_in to 0", test_num);
            bus_in = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Drive bus_in to 1", test_num);
            bus_in = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Drive bus_in to 0 then Z (Hold 0)", test_num);
            bus_in = 1'b0;
            #10;
            bus_in = 1'bz;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Drive bus_in to 1 then Z (Hold 1)", test_num);
            bus_in = 1'b1;
            #10;
            bus_in = 1'bz;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transition 0 -> 1 -> Z", test_num);
            bus_in = 1'b0;
            #10;
            bus_in = 1'b1;
            #10;
            bus_in = 1'bz;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition 1 -> 0 -> Z", test_num);
            bus_in = 1'b1;
            #10;
            bus_in = 1'b0;
            #10;
            bus_in = 1'bz;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify output is not affected by repeated Z updates", test_num);
            bus_in = 1'b1;
            #10;
            bus_in = 1'bz;
            #10;
            bus_in = 1'bz;
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
        input expected_bus_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus_out === (expected_bus_out ^ bus_out ^ expected_bus_out)) begin
                $display("PASS");
                $display("  Outputs: bus_out=%b",
                         bus_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_out=%b",
                         expected_bus_out);
                $display("  Got:      bus_out=%b",
                         bus_out);
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
