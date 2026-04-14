`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg [15:0] w1;
    reg [15:0] w2;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            w1 = 16'h0000;
            w2 = 16'h0000;
            b  = 16'h0000;
            x1 = 16'h0000;
            x2 = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple identity (w1=1, rest 0)", test_num);
            w1 = 16'h0001;
            w2 = 16'h0000;
            b  = 16'h0000;
            x1 = 16'h0064;
            x2 = 16'h00C8;
            #1;

            check_outputs(16'h0064);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Weight w2 and bias", test_num);
            w1 = 16'h0000;
            w2 = 16'h0002;
            b  = 16'h000A;
            x1 = 16'h0005;
            x2 = 16'h000F;
            #1;

            check_outputs(16'h0028);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple weights and bias", test_num);
            w1 = 16'h0003;
            w2 = 16'h0004;
            b  = 16'h0005;
            x1 = 16'h000A;
            x2 = 16'h0014;

            #1;


            check_outputs(16'h0073);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative weight (2's complement)", test_num);
            w1 = 16'hFFFF;
            w2 = 16'h0001;
            b  = 16'h0000;
            x1 = 16'h0005;
            x2 = 16'h000A;

            #1;


            check_outputs(16'h0005);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large bias only", test_num);
            w1 = 16'h0000;
            w2 = 16'h0000;
            b  = 16'h1234;
            x1 = 16'hFFFF;
            x2 = 16'hFFFF;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Result wrap-around / Truncation check", test_num);

            w1 = 16'h0100;
            w2 = 16'h0000;
            b  = 16'h0001;
            x1 = 16'h0100;
            x2 = 16'h0000;


            #1;



            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative result (2's complement)", test_num);
            w1 = 16'h0001;
            w2 = 16'h0000;
            b  = 16'hFFFE;
            x1 = 16'h0001;
            x2 = 16'h0000;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
