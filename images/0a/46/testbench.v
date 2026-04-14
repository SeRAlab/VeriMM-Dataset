`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_reg_prev;
    reg [4:0] src_reg_curr;
    wire forward;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest_reg_prev(dest_reg_prev),
        .src_reg_curr(src_reg_curr),
        .forward(forward)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Matching registers (Reg 5)");
        dest_reg_prev = 5'd5;
        src_reg_curr = 5'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Different registers (Reg 10 vs Reg 20)");
        dest_reg_prev = 5'd10;
        src_reg_curr = 5'd20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Maximum register index match (Reg 31)");
        dest_reg_prev = 5'd31;
        src_reg_curr = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Close but not equal indices (Reg 15 vs Reg 14)");
        dest_reg_prev = 5'd15;
        src_reg_curr = 5'd14;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Register 0 match check");
        dest_reg_prev = 5'd0;
        src_reg_curr = 5'd0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Bit-flipped pattern (Reg 10 (1010) vs Reg 21 (10101))");
        dest_reg_prev = 5'b01010;
        src_reg_curr = 5'b10101;
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
        $display("data_forwarding_unit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_forward;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward === (expected_forward ^ forward ^ expected_forward)) begin
                $display("PASS");
                $display("  Outputs: forward=%b",
                         forward);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward=%b",
                         expected_forward);
                $display("  Got:      forward=%b",
                         forward);
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
