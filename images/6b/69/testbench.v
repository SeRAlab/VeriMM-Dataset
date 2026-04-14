`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg add;
    reg [26:0] opa;
    reg [26:0] opb;
    wire co;
    wire [26:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .opa(opa),
        .opb(opb),
        .co(co),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        add = 1'b1;
        opa = 27'h000000A;
        opb = 27'h0000005;
        #1;

        check_outputs(1'b0, 27'h000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        add = 1'b1;
        opa = 27'h7FFFFFF;
        opb = 27'h0000001;
        #1;

        check_outputs(1'b1, 27'h0000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        add = 1'b0;
        opa = 27'h0000064;
        opb = 27'h0000032;
        #1;

        check_outputs(1'b0, 27'h0000032);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        add = 1'b0;
        opa = 27'h1234567;
        opb = 27'h1234567;
        #1;

        check_outputs(1'b0, 27'h0000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        add = 1'b0;
        opa = 27'h0000000;
        opb = 27'h0000001;
        #1;

        check_outputs(1'b1, 27'h7FFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        add = 1'b1;
        opa = 27'h4000000;
        opb = 27'h4000000;
        #1;

        check_outputs(1'b1, 27'h0000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        add = 1'b1;
        opa = 27'h0;
        opb = 27'h0;
        #1;

        check_outputs(1'b0, 27'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        add = 1'b0;
        opa = 27'h7FFFFFF;
        opb = 27'h0000001;
        #1;

        check_outputs(1'b0, 27'h7FFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_co;
        input [26:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_co === (expected_co ^ co ^ expected_co) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: co=%b, sum=%h",
                         co, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co=%b, sum=%h",
                         expected_co, expected_sum);
                $display("  Got:      co=%b, sum=%h",
                         co, sum);
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
