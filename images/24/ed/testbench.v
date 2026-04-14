`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] source;
    reg [24:0] weights;
    wire [39:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .source(source),
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Path 0 -> 1 -> 2 -> 3 -> 4", test_num);
            source = 3'd0;


            weights = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);

            #1;


            check_outputs(40'h04_03_02_01_00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Star Graph (Source 0 connects to all)", test_num);
            source = 3'd0;


            weights = 25'h000001E;

            #1;


            check_outputs(40'h01_01_01_01_00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disconnected Graph", test_num);
            source = 3'd0;


            weights = (1 << 1) | (1 << 7) | (1 << 19);

            #1;


            check_outputs(40'hFF_FF_02_01_00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fully Connected Graph from Source 2", test_num);
            source = 3'd2;

            weights = 25'h1FFFFFF;

            #1;


            check_outputs(40'h01_01_00_01_01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reverse Linear Path 4 -> 3 -> 2 -> 1 -> 0", test_num);
            source = 3'd4;


            weights = (1 << 23) | (1 << 17) | (1 << 11) | (1 << 5);

            #1;


            check_outputs(40'h00_01_02_03_04);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Graph with redundant longer path", test_num);
            source = 3'd0;



            weights = (1 << 1) | (1 << 7) | (1 << 2);

            #1;


            check_outputs(40'hFF_FF_01_01_00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bellman_ford Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [39:0] expected_distances;
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
