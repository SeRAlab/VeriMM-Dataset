`timescale 1ns/1ps

module FloydWarshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] weights;
    wire [15:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FloydWarshall dut (
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

        begin
            test_num = 1;
            weights = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            weights = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            weights = 16'h4210;
            #1;

            check_outputs(16'h7310);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            weights = 16'h4218;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            weights = 16'h4812;
            #1;

            check_outputs(16'hCC33);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            weights = 16'h7000;
            #1;

            check_outputs(16'h7000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            weights = 16'h4300;
            #1;

            check_outputs(16'h7300);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            weights = 16'h4280;
            #1;

            check_outputs(16'hEEE0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FloydWarshall Testbench");
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
        input [15:0] expected_distances;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distances === (expected_distances ^ distances ^ expected_distances)) begin
                $display("PASS");
                $display("  Outputs: distances=%h",
                         distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distances=%h",
                         expected_distances);
                $display("  Got:      distances=%h",
                         distances);
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
