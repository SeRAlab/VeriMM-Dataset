`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] weights;
    wire [255:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

        begin
            weights = {
                ZERO, INF,  INF,  INF,
                INF,  ZERO, INF,  INF,
                INF,  INF,  ZERO, INF,
                INF,  INF,  INF,  ZERO
            };
            #1;

            check_outputs(weights);
        end
        endtask

    task testcase002;

        reg [255:0] expected;
        begin
            weights = {
                ZERO, 16'd2, INF,   INF,
                INF,  ZERO,  16'd3, INF,
                INF,  INF,   ZERO,  16'd4,
                INF,  INF,   INF,   ZERO
            };




            expected = {
                ZERO, 16'd2, 16'd5, 16'd9,
                INF,  ZERO,  16'd3, 16'd7,
                INF,  INF,   ZERO,  16'd4,
                INF,  INF,   INF,   ZERO
            };
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [255:0] expected;
        begin
            weights = {
                ZERO, 16'd10, 16'd2, INF,
                INF,  ZERO,   INF,   INF,
                INF,  16'd3,  ZERO,  INF,
                INF,  INF,    INF,   ZERO
            };
            expected = {
                ZERO, 16'd5,  16'd2, INF,
                INF,  ZERO,   INF,   INF,
                INF,  16'd3,  ZERO,  INF,
                INF,  INF,    INF,   ZERO
            };
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [255:0] expected;
        begin
            weights = {
                ZERO,  16'd1, INF,   INF,
                INF,   ZERO,  16'd1, INF,
                INF,   INF,   ZERO,  16'd1,
                16'd1, INF,   INF,   ZERO
            };



            expected = {
                ZERO,  16'd1, 16'd2, 16'd3,
                16'd3, ZERO,  16'd1, 16'd2,
                16'd2, 16'd3, ZERO,  16'd1,
                16'd1, 16'd2, 16'd3, ZERO
            };
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [255:0] expected;
        begin
            weights = {
                ZERO,  16'd5,  INF,    16'd10,
                INF,   ZERO,   16'd3,  INF,
                INF,   INF,    ZERO,   16'd1,
                INF,   INF,    INF,    ZERO
            };




            expected = {
                ZERO,  16'd5,  16'd8,  16'd9,
                INF,   ZERO,   16'd3,  16'd4,
                INF,   INF,    ZERO,   16'd1,
                INF,   INF,    INF,    ZERO
            };
            #1;

            check_outputs(expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floyd_warshall Testbench");
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
        input [255:0] expected_distances;
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
