`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] condition;
    reg n;
    reg ov;
    reg taken;
    reg z;
    wire miss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .condition(condition),
        .n(n),
        .ov(ov),
        .taken(taken),
        .z(z),
        .miss(miss)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition EQ (0), z=1, taken=1", test_num);
        condition = 3'b000;
        z = 1;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition EQ (0), z=0, taken=1", test_num);
        condition = 3'b000;
        z = 0;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition NE (1), z=0, taken=1", test_num);
        condition = 3'b001;
        z = 0;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition NE (1), z=1, taken=1", test_num);
        condition = 3'b001;
        z = 1;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition GE (2), n=1, ov=1, taken=1", test_num);
        condition = 3'b010;
        z = 0;
        ov = 1;
        n = 1;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition GE (2), n=1, ov=0, taken=1", test_num);
        condition = 3'b010;
        z = 0;
        ov = 0;
        n = 1;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition LT (3), n=1, ov=0, taken=1", test_num);
        condition = 3'b011;
        z = 0;
        ov = 0;
        n = 1;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition LT (3), n=0, ov=0, taken=1", test_num);
        condition = 3'b011;
        z = 0;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition GT (4), n=0, ov=0, z=0, taken=1", test_num);
        condition = 3'b100;
        z = 0;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition GT (4), n=0, ov=0, z=1, taken=1", test_num);
        condition = 3'b100;
        z = 1;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition LE (5), n=1, ov=0, z=0, taken=1", test_num);
        condition = 3'b101;
        z = 0;
        ov = 0;
        n = 1;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition LE (5), n=0, ov=0, z=1, taken=1", test_num);
        condition = 3'b101;
        z = 1;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition Always (6), taken=1", test_num);
        condition = 3'b110;
        z = 0;
        ov = 0;
        n = 0;
        taken = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition Never (7), taken=1", test_num);
        condition = 3'b111;
        z = 1;
        ov = 1;
        n = 1;
        taken = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Condition EQ (0), z=1, taken=0", test_num);
        condition = 3'b000;
        z = 1;
        ov = 0;
        n = 0;
        taken = 0;
        #1;

        check_outputs(1'b1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_miss;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_miss === (expected_miss ^ miss ^ expected_miss)) begin
                $display("PASS");
                $display("  Outputs: miss=%b",
                         miss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miss=%b",
                         expected_miss);
                $display("  Got:      miss=%b",
                         miss);
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
