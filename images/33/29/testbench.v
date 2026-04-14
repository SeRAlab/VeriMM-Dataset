`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero addition (0 + 0)", test_num);
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small positive addition (5 + 10)", test_num);
        a = 16'h0005;
        b = 16'h000A;
        #1;

        check_outputs(16'h000F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical hex addition (0x1234 + 0x4321)", test_num);
        a = 16'h1234;
        b = 16'h4321;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive and negative (10 + -5)", test_num);
        a = 16'h000A;
        b = 16'hFFFB;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative and positive (-10 + 5)", test_num);
        a = 16'hFFF6;
        b = 16'h0005;
        #1;

        check_outputs(16'hFFFB);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two negative numbers (-1 + -1)", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum signed value addition (0x7FFF + 1)", test_num);
        a = 16'h7FFF;
        b = 16'h0001;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 16-bit unsigned wrap around (0xFFFF + 1)", test_num);
        a = 16'hFFFF;
        b = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition resulting in all ones (0xAAAA + 0x5555)", test_num);
        a = 16'hAAAA;
        b = 16'h5555;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum negative values addition (0x8000 + 0x8000)", test_num);
        a = 16'h8000;
        b = 16'h8000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
