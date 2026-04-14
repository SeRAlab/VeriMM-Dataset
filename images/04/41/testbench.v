`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    wire [5:0] sum;

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
        test_num = 1;
        $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
        a = 5'd0;
        b = 5'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Max Value (31 + 31)", test_num);
        a = 5'd31;
        b = 5'd31;
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Simple Addition (10 + 5)", test_num);
        a = 5'd10;
        b = 5'd5;
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Power of 2 result (16 + 16)", test_num);
        a = 5'd16;
        b = 5'd16;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Addition with zero (0 + 25)", test_num);
        a = 5'd0;
        b = 5'd25;
        #1;

        check_outputs(6'd25);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary check (31 + 1)", test_num);
        a = 5'd31;
        b = 5'd1;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Random values (12 + 19)", test_num);
        a = 5'd12;
        b = 5'd19;
        #1;

        check_outputs(6'd31);
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
        input [5:0] expected_sum;
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
