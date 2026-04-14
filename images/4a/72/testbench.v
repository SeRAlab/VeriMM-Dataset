`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum inputs (0 + 0)", test_num);
        a = 4'd0;
        b = 4'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple addition without carry (5 + 3)", test_num);
        a = 4'd5;
        b = 4'd3;
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Carry out to 5th bit (8 + 8)", test_num);
        a = 4'd8;
        b = 4'd8;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 4-bit plus zero (15 + 0)", test_num);
        a = 4'd15;
        b = 4'd0;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 4-bit plus one (15 + 1)", test_num);
        a = 4'd15;
        b = 4'd1;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum possible sum (15 + 15)", test_num);
        a = 4'd15;
        b = 4'd15;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Typical values with carry (10 + 7)", test_num);
        a = 4'd10;
        b = 4'd7;
        #1;

        check_outputs(5'd17);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random addition (12 + 13)", test_num);
        a = 4'd12;
        b = 4'd13;
        #1;

        check_outputs(5'd25);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
        input [4:0] expected_sum;
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
