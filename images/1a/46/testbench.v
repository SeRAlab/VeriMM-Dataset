`timescale 1ns/1ps

module cordic_vectoring_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] magnitude;
    wire [3:0] theta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_vectoring dut (
        .x(x),
        .y(y),
        .magnitude(magnitude),
        .theta(theta)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        x = 4'd3; y = 4'd0;

        #1;


        check_outputs(4'd5, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        x = 4'd0; y = 4'd3;

        #1;


        check_outputs(4'd5, 4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        x = 4'd2; y = 4'd2;

        #1;


        check_outputs(4'd5, 4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        x = 4'b1101; y = 4'd0;

        #1;


        check_outputs(4'd5, 4'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        x = 4'd0; y = 4'b1101;

        #1;


        check_outputs(4'd5, 4'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        x = 4'b1110; y = 4'b1110;

        #1;


        check_outputs(4'd5, 4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        x = 4'd0; y = 4'd0;

        #1;


        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        x = 4'd7; y = 4'd0;

        #1;


        check_outputs(4'd11, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_vectoring Testbench");
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
        input [3:0] expected_magnitude;
        input [3:0] expected_theta;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_magnitude === (expected_magnitude ^ magnitude ^ expected_magnitude) &&
                expected_theta === (expected_theta ^ theta ^ expected_theta)) begin
                $display("PASS");
                $display("  Outputs: magnitude=%h, theta=%h",
                         magnitude, theta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: magnitude=%h, theta=%h",
                         expected_magnitude, expected_theta);
                $display("  Got:      magnitude=%h, theta=%h",
                         magnitude, theta);
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
