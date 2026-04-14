`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .A(A),
        .B(B),
        .GT(GT)
    );
    task testcase001;

    begin
        A = 4'd10; B = 4'd5;
        $display("Testcase001: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        A = 4'd3; B = 4'd7;
        $display("Testcase002: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        A = 4'd8; B = 4'd8;
        $display("Testcase003: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        A = 4'd15; B = 4'd0;
        $display("Testcase004: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        A = 4'd0; B = 4'd15;
        $display("Testcase005: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        A = 4'd0; B = 4'd0;
        $display("Testcase006: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        A = 4'd15; B = 4'd15;
        $display("Testcase007: A=%d, B=%d", A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        A = 4'd1; B = 4'd0;
        $display("Testcase008: A=%d, B=%d", A, B);
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
        $display("comparator Testbench");
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
        input expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: GT=%b",
                         GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GT=%b",
                         expected_GT);
                $display("  Got:      GT=%b",
                         GT);
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
