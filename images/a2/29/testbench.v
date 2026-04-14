`timescale 1ns/1ps

module priority_encoder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    wire y0;
    wire y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4bit dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .y0(y0),
        .y1(y1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs low (0000)", test_num);
        d3 = 0; d2 = 0; d1 = 0; d0 = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lowest priority input high (0001)", test_num);
        d3 = 0; d2 = 0; d1 = 0; d0 = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input d1 high (0010)", test_num);
        d3 = 0; d2 = 0; d1 = 1; d0 = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority check d1 over d0 (0011)", test_num);
        d3 = 0; d2 = 0; d1 = 1; d0 = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input d2 high (0100)", test_num);
        d3 = 0; d2 = 1; d1 = 0; d0 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority check d2 over d1, d0 (0111)", test_num);
        d3 = 0; d2 = 1; d1 = 1; d0 = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Highest priority input high (1000)", test_num);
        d3 = 1; d2 = 0; d1 = 0; d0 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs high (1111)", test_num);
        d3 = 1; d2 = 1; d1 = 1; d0 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority check d3 over d1 (1010)", test_num);
        d3 = 1; d2 = 0; d1 = 1; d0 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse inputs (0101)", test_num);
        d3 = 0; d2 = 1; d1 = 0; d0 = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4bit Testbench");
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
        input expected_y0;
        input expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%b, y1=%b",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%b, y1=%b",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%b, y1=%b",
                         y0, y1);
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
