`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] b;
    wire [15:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x(x),
        .y(y),
        .b(b),
        .m(m)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity relationship (y = x)", test_num);

        x = 16'h0001;
        y = 16'h0001;


        #1;



        check_outputs(16'h0000, 16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple offset (y = x + 2)", test_num);

        x = 16'h0002;
        y = 16'h0004;


        #1;



        check_outputs(16'h0002, 16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Steeper slope (y = 2x)", test_num);

        x = 16'h0003;
        y = 16'h0006;


        #1;



        check_outputs(16'h0000, 16'h0002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative slope (y = -x + 10)", test_num);

        x = 16'h0002;
        y = 16'h0008;


        #1;



        check_outputs(16'h000A, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal line (y = 5)", test_num);

        x = 16'h000A;
        y = 16'h0005;


        #1;



        check_outputs(16'h0005, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Origin input", test_num);

        x = 16'h0000;
        y = 16'h0000;


        #1;



        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High value inputs", test_num);

        x = 16'h0100;
        y = 16'h0200;


        #1;



        check_outputs(16'h0000, 16'h0002);
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
        input [15:0] expected_b;
        input [15:0] expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: b=%h, m=%h",
                         b, m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, m=%h",
                         expected_b, expected_m);
                $display("  Got:      b=%h, m=%h",
                         b, m);
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
