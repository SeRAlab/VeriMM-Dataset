`timescale 1ns/1ps

module rgb_to_grayscale_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] rgb_pixel;
    wire [3:0] grayscale;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rgb_to_grayscale dut (
        .rgb_pixel(rgb_pixel),
        .grayscale(grayscale)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros (Black)");
        rgb_pixel = 8'b000_000_00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: All Ones (White)");
        rgb_pixel = 8'b111_111_11;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Maximum Red Only");
        rgb_pixel = 8'b111_000_00;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Maximum Green Only");
        rgb_pixel = 8'b000_111_00;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Maximum Blue Only");
        rgb_pixel = 8'b000_000_11;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Balanced Components");
        rgb_pixel = 8'b010_010_10;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Mixed Values 1 (Result 4)");
        rgb_pixel = 8'b101_110_01;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Mixed Values 2 (Result 3)");
        rgb_pixel = 8'b110_011_00;
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rgb_to_grayscale Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_grayscale;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grayscale === (expected_grayscale ^ grayscale ^ expected_grayscale)) begin
                $display("PASS");
                $display("  Outputs: grayscale=%h",
                         grayscale);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grayscale=%h",
                         expected_grayscale);
                $display("  Got:      grayscale=%h",
                         grayscale);
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
