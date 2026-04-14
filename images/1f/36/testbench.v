`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] edges;
    reg [4:0] src;
    reg [4:0] weights;
    wire [4:0] dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .edges(edges),
        .src(src),
        .weights(weights),
        .dist(dist)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero (Source 0, No Edges, No Weights)", test_num);
            src = 5'd0;
            edges = 5'd0;
            weights = 5'd0;

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 1, basic edge and weight configuration", test_num);
            src = 5'd1;
            edges = 5'b00101;
            weights = 5'b01010;


            #1;



            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 2, alternate edge pattern", test_num);
            src = 5'd2;
            edges = 5'b11000;
            weights = 5'b00111;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing maximum weight value", test_num);
            src = 5'd3;
            edges = 5'b01110;
            weights = 5'b11111;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source at maximum index", test_num);
            src = 5'b11111;
            edges = 5'b10101;
            weights = 5'b00011;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed edge bits with zero weights", test_num);
            src = 5'd4;
            edges = 5'b11111;
            weights = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow check pattern", test_num);
            src = 5'd5;
            edges = 5'b10001;
            weights = 5'b11000;
            #1;

            check_outputs(5'd24);
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
        input [4:0] expected_dist;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dist === (expected_dist ^ dist ^ expected_dist)) begin
                $display("PASS");
                $display("  Outputs: dist=%h",
                         dist);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dist=%h",
                         expected_dist);
                $display("  Got:      dist=%h",
                         dist);
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
