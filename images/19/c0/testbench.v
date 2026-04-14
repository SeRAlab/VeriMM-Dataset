`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg select_A;
    reg select_B;
    wire [3:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .A(A),
        .B(B),
        .select_A(select_A),
        .select_B(select_B),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Select A (Nearest Neighbor is A)");

        A = 2'b01;
        B = 2'b10;
        select_A = 1'b1;
        select_B = 1'b0;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Select B (Nearest Neighbor is B)");
        A = 2'b01;
        B = 2'b11;
        select_A = 1'b0;
        select_B = 1'b1;

        #1;


        check_outputs(4'b0011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Select Neither (Default Intensity)");
        A = 2'b11;
        B = 2'b11;
        select_A = 1'b0;
        select_B = 1'b0;

        #1;


        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Priority Check (Both Selects High)");
        A = 2'b00;
        B = 2'b11;
        select_A = 1'b1;
        select_B = 1'b1;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Select B with different input values");
        A = 2'b00;
        B = 2'b00;
        select_A = 1'b0;
        select_B = 1'b1;

        #1;


        check_outputs(4'b0011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_interpolated_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_pixel === (expected_interpolated_pixel ^ interpolated_pixel ^ expected_interpolated_pixel)) begin
                $display("PASS");
                $display("  Outputs: interpolated_pixel=%h",
                         interpolated_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_pixel=%h",
                         expected_interpolated_pixel);
                $display("  Got:      interpolated_pixel=%h",
                         interpolated_pixel);
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
