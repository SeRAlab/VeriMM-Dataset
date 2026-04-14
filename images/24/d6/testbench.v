`timescale 1ns/1ps

module knn_compare_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] point_a;
    reg [3:0] point_b;
    wire neighbor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_compare dut (
        .point_a(point_a),
        .point_b(point_b),
        .neighbor(neighbor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        point_a = 4'b0000;
        point_b = 4'b0000;
        $display("Test %0d: Same point (0,0) and (0,0) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        point_a = 4'b0000;
        point_b = 4'b0001;
        $display("Test %0d: Manhattan Distance 1 (0,0) and (0,1) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        point_a = 4'b0000;
        point_b = 4'b0110;
        $display("Test %0d: Manhattan Distance 3 (0,0) and (1,2) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        point_a = 4'b0000;
        point_b = 4'b0011;
        $display("Test %0d: Manhattan Distance 3 (0,0) and (0,3) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        point_a = 4'b1010;
        point_b = 4'b0000;
        $display("Test %0d: Manhattan Distance 4 (2,2) and (0,0) - Expected: 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        point_a = 4'b1111;
        point_b = 4'b0000;
        $display("Test %0d: Max Manhattan Distance 6 (3,3) and (0,0) - Expected: 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        point_a = 4'b0101;
        point_b = 4'b1010;
        $display("Test %0d: Diagonal Distance 2 (1,1) and (2,2) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        point_a = 4'b1100;
        point_b = 4'b0011;
        $display("Test %0d: Manhattan Distance 6 (3,0) and (0,3) - Expected: 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        point_a = 4'b1101;
        point_b = 4'b1011;
        $display("Test %0d: Manhattan Distance 3 (3,1) and (2,3) - Expected: 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        point_a = 4'b1001;
        point_b = 4'b0111;
        $display("Test %0d: Manhattan Distance 3 (2,1) and (1,3) - Expected: 1", test_num);
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
        $display("knn_compare Testbench");
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
        input expected_neighbor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_neighbor === (expected_neighbor ^ neighbor ^ expected_neighbor)) begin
                $display("PASS");
                $display("  Outputs: neighbor=%b",
                         neighbor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: neighbor=%b",
                         expected_neighbor);
                $display("  Got:      neighbor=%b",
                         neighbor);
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
