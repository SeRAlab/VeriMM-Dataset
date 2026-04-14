`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] weights;
    wire [15:0] dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .weights(weights),
        .dist(dist)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Linear Chain (0->1->2->3)", test_num);






        weights = {
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd15,  10'd0,   10'd999, 10'd999,
            10'd999, 10'd10,  10'd0,   10'd999,
            10'd999, 10'd999, 10'd5,   10'd0
        };





        #1;






        check_outputs({
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd15,  10'd0,   10'd999, 10'd999,
            10'd25,  10'd10,  10'd0,   10'd999,
            10'd30,  10'd15,  10'd5,   10'd0
        });
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Path Shortcut Detour", test_num);





        weights = {
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd999, 10'd0,   10'd5,   10'd999,
            10'd10,  10'd999, 10'd0,   10'd999,
            10'd999, 10'd20,  10'd50,  10'd0
        };





        #1;






        check_outputs({
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd15,  10'd0,   10'd5,   10'd999,
            10'd10,  10'd999, 10'd0,   10'd999,
            10'd35,  10'd20,  10'd25,  10'd0
        });
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Disconnected Graph", test_num);

        weights = {
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd999, 10'd0,   10'd999, 10'd999,
            10'd999, 10'd999, 10'd0,   10'd999,
            10'd999, 10'd999, 10'd999, 10'd0
        };


        #1;



        check_outputs({
            10'd0,   10'd999, 10'd999, 10'd999,
            10'd999, 10'd0,   10'd999, 10'd999,
            10'd999, 10'd999, 10'd0,   10'd999,
            10'd999, 10'd999, 10'd999, 10'd0
        });
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Direct Edges (W=10)", test_num);

        weights = {
            10'd0,   10'd10,  10'd10,  10'd10,
            10'd10,  10'd0,   10'd10,  10'd10,
            10'd10,  10'd10,  10'd0,   10'd10,
            10'd10,  10'd10,  10'd10,  10'd0
        };


        #1;



        check_outputs({
            10'd0,   10'd10,  10'd10,  10'd10,
            10'd10,  10'd0,   10'd10,  10'd10,
            10'd10,  10'd10,  10'd0,   10'd10,
            10'd10,  10'd10,  10'd10,  10'd0
        });
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
        input [15:0] expected_dist;
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
