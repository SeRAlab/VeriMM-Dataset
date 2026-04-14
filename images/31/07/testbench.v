`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] edges;
    reg [4:0] src;
    wire [39:0] dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .edges(edges),
        .src(src),
        .dist(dist)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 0, Unit Weights", test_num);
            src = 5'd0;

            edges = 20'h08421;


            #1;



            check_outputs(40'h0403020100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 1, Unit Weights", test_num);
            src = 5'd1;
            edges = 20'h08421;

            #1;


            check_outputs(40'h03020100FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 0, Varying Weights", test_num);
            src = 5'd0;

            edges = {5'd8, 5'd6, 5'd4, 5'd2};


            #1;



            check_outputs(40'h140C060200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 4 (Sink Node)", test_num);
            src = 5'd4;
            edges = 20'hFFFFF;

            #1;


            check_outputs(40'h00FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Possible Edge Weights", test_num);
            src = 5'd0;
            edges = 20'hFFFFF;


            #1;



            check_outputs(40'h7C5D3E1F00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source 2, Zero Weights", test_num);
            src = 5'd2;
            edges = 20'h00000;

            #1;


            check_outputs(40'h000000FFFF);
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
        input [39:0] expected_dist;
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
