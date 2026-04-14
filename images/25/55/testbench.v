`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dx;
    reg [15:0] dy;
    reg [15:0] learning_rate;
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] x_new;
    wire [15:0] y_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .dx(dx),
        .dy(dy),
        .learning_rate(learning_rate),
        .x(x),
        .y(y),
        .x_new(x_new),
        .y_new(y_new)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            x = 16'h0000;
            y = 16'h0000;
            dx = 16'h0000;
            dy = 16'h0000;
            learning_rate = 16'h0005;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Positive Step", test_num);
            x = 16'd100;
            y = 16'd200;
            dx = 16'd2;
            dy = 16'd4;
            learning_rate = 16'd10;


            #1;



            check_outputs(16'h0050, 16'h00A0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate", test_num);
            x = 16'h1234;
            y = 16'h5678;
            dx = 16'h00FF;
            dy = 16'h00FF;
            learning_rate = 16'h0000;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Gradients (Ascent)", test_num);
            x = 16'd50;
            y = 16'd50;
            dx = -16'd5;
            dy = -16'd2;
            learning_rate = 16'd10;


            #1;



            check_outputs(16'h0064, 16'h0046);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result Underflow (Negative)", test_num);
            x = 16'd10;
            y = 16'd10;
            dx = 16'd5;
            dy = 16'd10;
            learning_rate = 16'd4;


            #1;



            check_outputs(16'hFFF6, 16'hFFE2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Step Truncation", test_num);
            x = 16'h0000;
            y = 16'hFFFF;
            dx = 16'h0100;
            dy = 16'h0001;
            learning_rate = 16'h0100;


            #1;



            check_outputs(16'h0000, 16'hFEFF);
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
        input [15:0] expected_x_new;
        input [15:0] expected_y_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new) &&
                expected_y_new === (expected_y_new ^ y_new ^ expected_y_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h, y_new=%h",
                         x_new, y_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h, y_new=%h",
                         expected_x_new, expected_y_new);
                $display("  Got:      x_new=%h, y_new=%h",
                         x_new, y_new);
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
