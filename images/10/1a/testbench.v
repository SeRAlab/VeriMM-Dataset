`timescale 1ns/1ps

module rrt_expansion_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] boundary_x;
    reg [7:0] boundary_y;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg [7:0] step_size;
    wire [7:0] new_x;
    wire [7:0] new_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_expansion dut (
        .boundary_x(boundary_x),
        .boundary_y(boundary_y),
        .current_x(current_x),
        .current_y(current_y),
        .step_size(step_size),
        .new_x(new_x),
        .new_y(new_y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard valid expansion within boundaries", test_num);
        boundary_x = 8'd100;
        boundary_y = 8'd100;
        current_x = 8'd20;
        current_y = 8'd30;
        step_size = 8'd10;

        #1;


        check_outputs(8'd30, 8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Expansion exceeds X boundary", test_num);
        boundary_x = 8'd50;
        boundary_y = 8'd100;
        current_x = 8'd45;
        current_y = 8'd20;
        step_size = 8'd10;

        #1;


        check_outputs(8'd45, 8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Expansion exceeds Y boundary", test_num);
        boundary_x = 8'd100;
        boundary_y = 8'd50;
        current_x = 8'd20;
        current_y = 8'd45;
        step_size = 8'd10;

        #1;


        check_outputs(8'd20, 8'd45);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Expansion exactly hits boundary limits", test_num);
        boundary_x = 8'd100;
        boundary_y = 8'd100;
        current_x = 8'd90;
        current_y = 8'd90;
        step_size = 8'd10;

        #1;


        check_outputs(8'd100, 8'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large step size exceeding both boundaries", test_num);
        boundary_x = 8'd50;
        boundary_y = 8'd50;
        current_x = 8'd10;
        current_y = 8'd10;
        step_size = 8'd100;

        #1;


        check_outputs(8'd10, 8'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero step size", test_num);
        boundary_x = 8'd100;
        boundary_y = 8'd100;
        current_x = 8'd50;
        current_y = 8'd50;
        step_size = 8'd0;

        #1;


        check_outputs(8'd50, 8'd50);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Expansion from origin", test_num);
        boundary_x = 8'd255;
        boundary_y = 8'd255;
        current_x = 8'd0;
        current_y = 8'd0;
        step_size = 8'd5;

        #1;


        check_outputs(8'd5, 8'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_expansion Testbench");
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
        input [7:0] expected_new_x;
        input [7:0] expected_new_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h",
                         new_x, new_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h",
                         expected_new_x, expected_new_y);
                $display("  Got:      new_x=%h, new_y=%h",
                         new_x, new_y);
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
