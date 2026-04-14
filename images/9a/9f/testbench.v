`timescale 1ns/1ps

module comparator_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_2bit dut (
        .a(a),
        .b(b),
        .gt(gt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=0 (Equal)", test_num);
        a = 2'b00;
        b = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=1, b=0 (A > B)", test_num);
        a = 2'b01;
        b = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=1 (A < B)", test_num);
        a = 2'b00;
        b = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=1, b=1 (Equal)", test_num);
        a = 2'b01;
        b = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=2, b=1 (A > B)", test_num);
        a = 2'b10;
        b = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=1, b=2 (A < B)", test_num);
        a = 2'b01;
        b = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=2, b=2 (Equal)", test_num);
        a = 2'b10;
        b = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=2 (A > B)", test_num);
        a = 2'b11;
        b = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=2, b=3 (A < B)", test_num);
        a = 2'b10;
        b = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=3 (Equal)", test_num);
        a = 2'b11;
        b = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=0 (Max vs Min)", test_num);
        a = 2'b11;
        b = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=3 (Min vs Max)", test_num);
        a = 2'b00;
        b = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_2bit Testbench");
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
        input expected_gt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gt === (expected_gt ^ gt ^ expected_gt)) begin
                $display("PASS");
                $display("  Outputs: gt=%b",
                         gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gt=%b",
                         expected_gt);
                $display("  Got:      gt=%b",
                         gt);
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
