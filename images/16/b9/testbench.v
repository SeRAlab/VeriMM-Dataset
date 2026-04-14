`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_parameters;
    reg [15:0] gradient;
    reg [7:0] learning_rate;
    wire [15:0] new_parameters;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .current_parameters(current_parameters),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .new_parameters(new_parameters)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic positive values", test_num);
            current_parameters = 16'h2000;
            gradient = 16'h0020;
            learning_rate = 8'h0A;

            #1;


            check_outputs(16'h1EC0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative result (wrap around)", test_num);
            current_parameters = 16'h0010;
            gradient = 16'h0011;
            learning_rate = 8'h01;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero learning rate", test_num);
            current_parameters = 16'h022B;
            gradient = 16'h1234;
            learning_rate = 8'h00;

            #1;


            check_outputs(16'h022B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero gradient", test_num);
            current_parameters = 16'hFFFF;
            gradient = 16'h0000;
            learning_rate = 8'hFF;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exact zero result", test_num);
            current_parameters = 16'h0200;
            gradient = 16'h0080;
            learning_rate = 8'h04;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values", test_num);
            current_parameters = 16'h8000;
            gradient = 16'h0005;
            learning_rate = 8'h64;

            #1;


            check_outputs(16'h7E0C);
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
        input [15:0] expected_new_parameters;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_parameters === (expected_new_parameters ^ new_parameters ^ expected_new_parameters)) begin
                $display("PASS");
                $display("  Outputs: new_parameters=%h",
                         new_parameters);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_parameters=%h",
                         expected_new_parameters);
                $display("  Got:      new_parameters=%h",
                         new_parameters);
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
