`timescale 1ns/1ps

module fsm_example4_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg h;
    reg [2:0] u;
    wire U0;
    wire x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_example4 dut (
        .clk(clk),
        .h(h),
        .u(u),
        .U0(U0),
        .x(x)
    );
    task testcase001;

    begin
        test_num = 1;
        u = 3'b000; h = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        u = 3'b000; h = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        u = 3'b001; h = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        u = 3'b001; h = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        u = 3'b010; h = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        u = 3'b010; h = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        u = 3'b011; h = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        u = 3'b011; h = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        u = 3'b100; h = 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        u = 3'b100; h = 1;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_example4 Testbench");
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
        input expected_U0;
        input expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U0 === (expected_U0 ^ U0 ^ expected_U0) &&
                expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: U0=%b, x=%b",
                         U0, x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U0=%b, x=%b",
                         expected_U0, expected_x);
                $display("  Got:      U0=%b, x=%b",
                         U0, x);
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
