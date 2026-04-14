`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] r1;
    reg [3:0] r2;
    reg [3:0] r3;
    reg [3:0] w1;
    reg [3:0] w2;
    reg [3:0] w3;
    wire [4:0] total_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .total_return(total_return)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs zero", test_num);
            w1 = 4'd0; r1 = 4'd0;
            w2 = 4'd0; r2 = 4'd0;
            w3 = 4'd0; r3 = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple values (result < 32)", test_num);
            w1 = 4'd2; r1 = 4'd3;
            w2 = 4'd1; r2 = 4'd4;
            w3 = 4'd2; r3 = 4'd2;
            #1;

            check_outputs(5'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single asset active", test_num);
            w1 = 4'd5; r1 = 4'd3;
            w2 = 4'd0; r2 = 4'd10;
            w3 = 4'd0; r3 = 4'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result at 5-bit boundary (31)", test_num);
            w1 = 4'd10; r1 = 4'd2;
            w2 = 4'd5;  r2 = 4'd2;
            w3 = 4'd1;  r3 = 4'd1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow check (32 wraps to 0)", test_num);
            w1 = 4'd8;  r1 = 4'd4;
            w2 = 4'd0;  r2 = 4'd0;
            w3 = 4'd0;  r3 = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: General overflow (45 wraps to 13)", test_num);
            w1 = 4'd15; r1 = 4'd1;
            w2 = 4'd15; r2 = 4'd1;
            w3 = 4'd15; r3 = 4'd1;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum possible inputs truncation", test_num);
            w1 = 4'd15; r1 = 4'd15;
            w2 = 4'd15; r2 = 4'd15;
            w3 = 4'd15; r3 = 4'd15;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Constant returns, varying weights", test_num);
            w1 = 4'd1;  r1 = 4'd10;
            w2 = 4'd2;  r2 = 4'd10;
            w3 = 4'd0;  r3 = 4'd10;
            #1;

            check_outputs(5'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [4:0] expected_total_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_return === (expected_total_return ^ total_return ^ expected_total_return)) begin
                $display("PASS");
                $display("  Outputs: total_return=%h",
                         total_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_return=%h",
                         expected_total_return);
                $display("  Got:      total_return=%h",
                         total_return);
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
