`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] array_in;
    wire [19:0] array_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .array_in(array_in),
        .array_out(array_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            array_in = 20'h54321;
            #1;

            check_outputs(20'h54321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            array_in = 20'h12345;

            #1;


            check_outputs(20'h54321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            array_in = 20'hAAAAA;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            array_in = 20'h28258;

            #1;


            check_outputs(20'h88522);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            array_in = 20'h0F72A;

            #1;


            check_outputs(20'hAF720);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            array_in = 20'h31415;

            #1;


            check_outputs(20'h54311);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            array_in = 20'hF0F08;

            #1;


            check_outputs(20'hFF800);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;

            array_in = 20'hF1234;

            #1;


            check_outputs(20'hF4321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [19:0] expected_array_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_array_out === (expected_array_out ^ array_out ^ expected_array_out)) begin
                $display("PASS");
                $display("  Outputs: array_out=%h",
                         array_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: array_out=%h",
                         expected_array_out);
                $display("  Got:      array_out=%h",
                         array_out);
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
