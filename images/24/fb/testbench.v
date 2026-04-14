`timescale 1ns/1ps

module monte_carlo_pi_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] points_inside_circle;
    reg [3:0] total_points;
    wire [15:0] pi_approximation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_pi dut (
        .points_inside_circle(points_inside_circle),
        .total_points(total_points),
        .pi_approximation(pi_approximation)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero points inside (Inside=0, Total=10)", test_num);
        points_inside_circle = 4'd0;
        total_points = 4'd10;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All points inside (Inside=10, Total=10)", test_num);
        points_inside_circle = 4'd10;
        total_points = 4'd10;


        #1;



        check_outputs(16'h4000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Half points inside (Inside=5, Total=10)", test_num);
        points_inside_circle = 4'd5;
        total_points = 4'd10;


        #1;



        check_outputs(16'h2000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Quarter ratio (Inside=3, Total=12)", test_num);
        points_inside_circle = 4'd3;
        total_points = 4'd12;


        #1;



        check_outputs(16'h1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three-quarter ratio (Inside=9, Total=12)", test_num);
        points_inside_circle = 4'd9;
        total_points = 4'd12;


        #1;



        check_outputs(16'h3000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pi Approximation (Inside=11, Total=14)", test_num);
        points_inside_circle = 4'd11;
        total_points = 4'd14;


        #1;



        check_outputs(16'h3249);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Low Approximation (Inside=7, Total=15)", test_num);
        points_inside_circle = 4'd7;
        total_points = 4'd15;


        #1;



        check_outputs(16'h1DDE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_pi Testbench");
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
        input [15:0] expected_pi_approximation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pi_approximation === (expected_pi_approximation ^ pi_approximation ^ expected_pi_approximation)) begin
                $display("PASS");
                $display("  Outputs: pi_approximation=%h",
                         pi_approximation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pi_approximation=%h",
                         expected_pi_approximation);
                $display("  Got:      pi_approximation=%h",
                         pi_approximation);
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
