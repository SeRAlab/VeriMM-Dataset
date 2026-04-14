`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_position;
    reg [15:0] learning_rate;
    wire [15:0] updated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .current_position(current_position),
        .learning_rate(learning_rate),
        .updated_position(updated_position)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic functional check", test_num);

            current_position = 16'd100;
            learning_rate = 16'd10;
            #1;

            check_outputs(16'd80);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero learning rate (no movement)", test_num);

            current_position = 16'd500;
            learning_rate = 16'd0;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Step resulting in zero", test_num);

            current_position = 16'd40;
            learning_rate = 16'd20;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Underflow / Negative result", test_num);


            current_position = 16'd10;
            learning_rate = 16'd10;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large input values", test_num);

            current_position = 16'd10000;
            learning_rate = 16'd1000;
            #1;

            check_outputs(16'd8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum position boundary", test_num);

            current_position = 16'hFFFF;
            learning_rate = 16'd1;
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_updated_position;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_position === (expected_updated_position ^ updated_position ^ expected_updated_position)) begin
                $display("PASS");
                $display("  Outputs: updated_position=%h",
                         updated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_position=%h",
                         expected_updated_position);
                $display("  Got:      updated_position=%h",
                         updated_position);
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
