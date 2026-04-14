`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_value;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    wire [15:0] new_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .current_value(current_value),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .new_value(new_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic gradient descent step", test_num);
            current_value = 16'h0064;
            learning_rate = 16'h0002;
            gradient     = 16'h000A;

            #1;


            check_outputs(16'h0050);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero gradient", test_num);
            current_value = 16'h01F4;
            learning_rate = 16'h0005;
            gradient     = 16'h0000;

            #1;


            check_outputs(16'h01F4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero learning rate", test_num);
            current_value = 16'h03E8;
            learning_rate = 16'h0000;
            gradient     = 16'h0032;

            #1;


            check_outputs(16'h03E8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step results in exactly zero", test_num);
            current_value = 16'h0190;
            learning_rate = 16'h0014;
            gradient     = 16'h0014;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow (negative result wraparound)", test_num);
            current_value = 16'h000A;
            learning_rate = 16'h0002;
            gradient     = 16'h0006;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large gradient step", test_num);
            current_value = 16'hFFFF;
            learning_rate = 16'h0001;
            gradient     = 16'h7FFF;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum product truncation (testing bits)", test_num);
            current_value = 16'h1234;
            learning_rate = 16'h0100;
            gradient     = 16'h0001;

            #1;


            check_outputs(16'h1134);
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
        input [15:0] expected_new_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_value === (expected_new_value ^ new_value ^ expected_new_value)) begin
                $display("PASS");
                $display("  Outputs: new_value=%h",
                         new_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_value=%h",
                         expected_new_value);
                $display("  Got:      new_value=%h",
                         new_value);
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
