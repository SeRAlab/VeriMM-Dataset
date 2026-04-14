`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] g;
    reg [15:0] lr;
    reg [15:0] x;
    wire [15:0] new_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .g(g),
        .lr(lr),
        .x(x),
        .new_x(new_x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Gradient", test_num);
            x  = 16'h0064;
            lr = 16'h0002;
            g  = 16'h0000;

            #1;


            check_outputs(16'h0064);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate", test_num);
            x  = 16'h03E8;
            lr = 16'h0000;
            g  = 16'h00FF;

            #1;


            check_outputs(16'h03E8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Gradient Step", test_num);
            x  = 16'h00C8;
            lr = 16'h0005;
            g  = 16'h000A;

            #1;


            check_outputs(16'h0096);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result Exactly Zero", test_num);
            x  = 16'h0100;
            lr = 16'h0010;
            g  = 16'h0010;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result Wrapping (Negative)", test_num);
            x  = 16'h0005;
            lr = 16'h0001;
            g  = 16'h000A;

            #1;


            check_outputs(16'hFFFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Values and Product Truncation", test_num);
            x  = 16'h0010;
            lr = 16'h0100;
            g  = 16'h0100;



            #1;




            check_outputs(16'h0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large X Minimal Step", test_num);
            x  = 16'hFFFF;
            lr = 16'h0001;
            g  = 16'h0001;

            #1;


            check_outputs(16'hFFFE);
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
        input [15:0] expected_new_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h",
                         new_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h",
                         expected_new_x);
                $display("  Got:      new_x=%h",
                         new_x);
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
