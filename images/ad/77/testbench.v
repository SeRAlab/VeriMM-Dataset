`timescale 1ns/1ps

module top_state_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg e;
    reg [1:0] r;
    wire R0;
    wire t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_state dut (
        .clk(clk),
        .e(e),
        .r(r),
        .R0(R0),
        .t(t)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: State=00, e=0", test_num);
            r = 2'b00;
            e = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: State=00, e=1", test_num);
            r = 2'b00;
            e = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: State=01, e=0", test_num);
            r = 2'b01;
            e = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: State=01, e=1", test_num);
            r = 2'b01;
            e = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: State=10, e=0", test_num);
            r = 2'b10;
            e = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: State=10, e=1", test_num);
            r = 2'b10;
            e = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: State=11, e=0", test_num);
            r = 2'b11;
            e = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: State=11, e=1", test_num);
            r = 2'b11;
            e = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_state Testbench");
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
        input expected_R0;
        input expected_t;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R0 === (expected_R0 ^ R0 ^ expected_R0) &&
                expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: R0=%b, t=%b",
                         R0, t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R0=%b, t=%b",
                         expected_R0, expected_t);
                $display("  Got:      R0=%b, t=%b",
                         R0, t);
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
