`timescale 1ns/1ps

module RRT_Node_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [1:0] direction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Node dut (
        .random_x(random_x),
        .random_y(random_y),
        .target_x(target_x),
        .target_y(target_y),
        .direction(direction)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure North Move", test_num);
        random_x = 8'd100; random_y = 8'd100;
        target_x = 8'd100; target_y = 8'd150;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure East Move", test_num);
        random_x = 8'd100; random_y = 8'd100;
        target_x = 8'd150; target_y = 8'd100;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure South Move", test_num);
        random_x = 8'd100; random_y = 8'd100;
        target_x = 8'd100; target_y = 8'd50;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pure West Move", test_num);
        random_x = 8'd100; random_y = 8'd100;
        target_x = 8'd50;  target_y = 8'd100;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: North-East (Closer to North)", test_num);
        random_x = 8'd10;  random_y = 8'd10;
        target_x = 8'd15;  target_y = 8'd30;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: North-East (Closer to East)", test_num);
        random_x = 8'd10;  random_y = 8'd10;
        target_x = 8'd30;  target_y = 8'd15;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Exact Diagonal Tie (NE)", test_num);
        random_x = 8'd10;  random_y = 8'd10;
        target_x = 8'd20;  target_y = 8'd20;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: South-West (Closer to West)", test_num);
        random_x = 8'd200; random_y = 8'd200;
        target_x = 8'd150; target_y = 8'd190;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identical Points", test_num);
        random_x = 8'd128; random_y = 8'd128;
        target_x = 8'd128; target_y = 8'd128;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Coordinate Delta", test_num);
        random_x = 8'd0;   random_y = 8'd0;
        target_x = 8'd255; target_y = 8'd1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Node Testbench");
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
        input [1:0] expected_direction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_direction === (expected_direction ^ direction ^ expected_direction)) begin
                $display("PASS");
                $display("  Outputs: direction=%h",
                         direction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direction=%h",
                         expected_direction);
                $display("  Got:      direction=%h",
                         direction);
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
