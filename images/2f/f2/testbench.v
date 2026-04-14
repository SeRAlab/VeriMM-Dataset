`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg [15:0] params;
    wire [15:0] updated_params;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .gradient(gradient),
        .learning_rate(learning_rate),
        .params(params),
        .updated_params(updated_params)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero Gradient (No change)", test_num);

            params = 16'h03E8;
            learning_rate = 16'h0005;
            gradient = 16'h0000;

            #1;


            check_outputs(16'h03E8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Zero Learning Rate (No change)", test_num);

            params = 16'h03E8;
            learning_rate = 16'h0000;
            gradient = 16'h000A;

            #1;


            check_outputs(16'h03E8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive Gradient (Descent)", test_num);

            params = 16'h01F4;
            learning_rate = 16'h0002;
            gradient = 16'h0014;

            #1;


            check_outputs(16'h01CC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative Gradient (Ascent)", test_num);

            params = 16'h01F4;
            learning_rate = 16'h0003;
            gradient = 16'hFFEC;


            #1;



            check_outputs(16'h0230);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Negative Parameter and Positive Gradient", test_num);

            params = 16'hFF9C;
            learning_rate = 16'h0002;
            gradient = 16'h0032;


            #1;



            check_outputs(16'hFF38);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Arithmetic Wrap-around (Underflow)", test_num);

            params = 16'h0005;
            learning_rate = 16'h000A;
            gradient = 16'h0002;


            #1;



            check_outputs(16'hFFF1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Large Values with Truncation", test_num);

            params = 16'h7FFF;
            learning_rate = 16'h00FF;
            gradient = 16'h0080;


            #1;



            check_outputs(16'h007F);
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
        input [15:0] expected_updated_params;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_params === (expected_updated_params ^ updated_params ^ expected_updated_params)) begin
                $display("PASS");
                $display("  Outputs: updated_params=%h",
                         updated_params);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_params=%h",
                         expected_updated_params);
                $display("  Got:      updated_params=%h",
                         updated_params);
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
