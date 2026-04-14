`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] weight_matrix;
    wire [15:0] shortest_path_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .weight_matrix(weight_matrix),
        .shortest_path_matrix(shortest_path_matrix)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Matrix (Self-loops only)", test_num);





        weight_matrix = 16'h8421;
        #1;

        check_outputs(16'h8421);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Linear Path 0->1->2->3", test_num);





        weight_matrix = 16'hC631;





        #1;






        check_outputs(16'hF731);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full Cycle 0->1->2->3->0", test_num);





        weight_matrix = 16'hC639;

        #1;


        check_outputs(16'hFFFF);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Disconnected Components {0,1} and {2,3}", test_num);




        weight_matrix = 16'hCC33;
        #1;

        check_outputs(16'hCC33);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Empty Graph (No Edges)", test_num);
        weight_matrix = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complete Graph (All Edges)", test_num);
        weight_matrix = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: DAG with Multiple Paths", test_num);





        weight_matrix = 16'hE531;





        #1;






        check_outputs(16'hF531);
    end
    endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Node 3 as Single Source to All", test_num);




        weight_matrix = 16'h842F;
        #1;

        check_outputs(16'h842F);
    end
    endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reverse Path 3->2->1->0", test_num);




        weight_matrix = 16'h8C63;





        #1;






        check_outputs(16'h8CEF);
    end
    endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Row of Edges (Row 0)", test_num);




        weight_matrix = 16'hF000;
        #1;

        check_outputs(16'hF000);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_shortest_path_matrix;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_path_matrix === (expected_shortest_path_matrix ^ shortest_path_matrix ^ expected_shortest_path_matrix)) begin
                $display("PASS");
                $display("  Outputs: shortest_path_matrix=%h",
                         shortest_path_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_path_matrix=%h",
                         expected_shortest_path_matrix);
                $display("  Got:      shortest_path_matrix=%h",
                         shortest_path_matrix);
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
