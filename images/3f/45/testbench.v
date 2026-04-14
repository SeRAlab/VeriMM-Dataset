`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] alpha;
    reg [15:0] grad;
    reg [15:0] x;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .grad(grad),
        .x(x),
        .x_new(x_new)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 16'd100;
            alpha = 16'd2;
            grad = 16'd5;
            #1;

            check_outputs(16'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 16'd500;
            alpha = 16'd0;
            grad = 16'd10;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 16'd500;
            alpha = 16'd10;
            grad = 16'd0;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 16'd10;
            alpha = 16'd1;
            grad = 16'd20;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 16'hFFFF;
            alpha = 16'd1;
            grad = 16'd1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 16'd1000;
            alpha = 16'd256;
            grad = 16'd256;


            #1;



            check_outputs(16'd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 16'd0;
            alpha = 16'd1;
            grad = 16'd1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 16'd1000;
            alpha = 16'd3;
            grad = 16'd300;
            #1;

            check_outputs(16'd100);
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
        input [15:0] expected_x_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h",
                         x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h",
                         expected_x_new);
                $display("  Got:      x_new=%h",
                         x_new);
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
