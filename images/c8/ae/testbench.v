`timescale 1ns/1ps

module count_ones_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    count_ones dut (
        .in(in),
        .count(count)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 4'b0000;
            #10;
            $display("Testcase %0d: Input 4'b0000 (0 ones)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 4'b0001;
            #10;
            $display("Testcase %0d: Input 4'b0001 (1 one)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 4'b0011;
            #10;
            $display("Testcase %0d: Input 4'b0011 (2 ones)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 4'b0101;
            #10;
            $display("Testcase %0d: Input 4'b0101 (2 ones - Example Pattern)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 4'b0111;
            #10;
            $display("Testcase %0d: Input 4'b0111 (3 ones)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 4'b1111;
            #10;
            $display("Testcase %0d: Input 4'b1111 (4 ones)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 4'b1000;
            #10;
            $display("Testcase %0d: Input 4'b1000 (1 one)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 4'b1011;
            #10;
            $display("Testcase %0d: Input 4'b1011 (3 ones)", test_num);
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
        $display("count_ones Testbench");
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
        input expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%b",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%b",
                         expected_count);
                $display("  Got:      count=%b",
                         count);
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
