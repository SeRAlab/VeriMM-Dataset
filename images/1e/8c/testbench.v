`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_weights;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    wire [15:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .current_weights(current_weights),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .updated_weights(updated_weights)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic functional check (Weight decrement)", test_num);
            current_weights = 16'd1000;
            learning_rate   = 16'd2;
            gradient        = 16'd50;

            #1;


            check_outputs(16'd900);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Zero learning rate", test_num);
            current_weights = 16'hAAAA;
            learning_rate   = 16'd0;
            gradient        = 16'd100;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Zero gradient", test_num);
            current_weights = 16'h5555;
            learning_rate   = 16'd10;
            gradient        = 16'd0;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Negative result (underflow)", test_num);
            current_weights = 16'd10;
            learning_rate   = 16'd1;
            gradient        = 16'd20;

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Large values and weight wrapping", test_num);
            current_weights = 16'h0000;
            learning_rate   = 16'd1;
            gradient        = 16'd1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Learning rate * gradient product truncation", test_num);
            current_weights = 16'd5000;
            learning_rate   = 16'd256;
            gradient        = 16'd256;


            #1;



            check_outputs(16'd5000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent_optimizer Testbench");
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
        input [15:0] expected_updated_weights;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: updated_weights=%h",
                         updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weights=%h",
                         expected_updated_weights);
                $display("  Got:      updated_weights=%h",
                         updated_weights);
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
