`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] start_x;
    reg [4:0] start_y;
    reg [4:0] target_x;
    reg [4:0] target_y;
    wire [7:0] estimated_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .start_x(start_x),
        .start_y(start_y),
        .target_x(target_x),
        .target_y(target_y),
        .estimated_cost(estimated_cost)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Same point (Distance 0)", test_num);
        start_x = 5'd10;
        start_y = 5'd10;
        target_x = 5'd10;
        target_y = 5'd10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pure horizontal movement", test_num);
        start_x = 5'd0;
        start_y = 5'd5;
        target_x = 5'd20;
        target_y = 5'd5;

        #1;


        check_outputs(8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pure vertical movement", test_num);
        start_x = 5'd15;
        start_y = 5'd2;
        target_x = 5'd15;
        target_y = 5'd25;

        #1;


        check_outputs(8'd23);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small diagonal step", test_num);
        start_x = 5'd1;
        start_y = 5'd1;
        target_x = 5'd2;
        target_y = 5'd2;

        #1;


        check_outputs(8'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: General Manhattan distance calculation", test_num);
        start_x = 5'd5;
        start_y = 5'd10;
        target_x = 5'd15;
        target_y = 5'd20;

        #1;


        check_outputs(8'd20);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Inverse direction (Negative offsets)", test_num);
        start_x = 5'd25;
        start_y = 5'd25;
        target_x = 5'd10;
        target_y = 5'd5;

        #1;


        check_outputs(8'd35);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible distance in 32x32 grid", test_num);
        start_x = 5'd0;
        start_y = 5'd0;
        target_x = 5'd31;
        target_y = 5'd31;

        #1;


        check_outputs(8'd62);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Corner to opposite corner", test_num);
        start_x = 5'd31;
        start_y = 5'd0;
        target_x = 5'd0;
        target_y = 5'd31;

        #1;


        check_outputs(8'd62);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Near boundary coordinates", test_num);
        start_x = 5'd30;
        start_y = 5'd1;
        target_x = 5'd1;
        target_y = 5'd30;

        #1;


        check_outputs(8'd58);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimal movement", test_num);
        start_x = 5'd16;
        start_y = 5'd16;
        target_x = 5'd16;
        target_y = 5'd17;

        #1;


        check_outputs(8'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
        input [7:0] expected_estimated_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_estimated_cost === (expected_estimated_cost ^ estimated_cost ^ expected_estimated_cost)) begin
                $display("PASS");
                $display("  Outputs: estimated_cost=%h",
                         estimated_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: estimated_cost=%h",
                         expected_estimated_cost);
                $display("  Got:      estimated_cost=%h",
                         estimated_cost);
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
