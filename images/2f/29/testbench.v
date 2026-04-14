`timescale 1ns/1ps

module data_forwarding_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] reg_dest_ex;
    reg [4:0] reg_dest_id;
    reg reg_valid_ex;
    reg reg_valid_id;
    wire forward_a;
    wire forward_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding dut (
        .reg_dest_ex(reg_dest_ex),
        .reg_dest_id(reg_dest_id),
        .reg_valid_ex(reg_valid_ex),
        .reg_valid_id(reg_valid_id),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All inputs zero/invalid", test_num);
            reg_dest_ex = 5'd0;
            reg_dest_id = 5'd0;
            reg_valid_ex = 1'b0;
            reg_valid_id = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Forwarding from EX stage only", test_num);
            reg_dest_ex = 5'd5;
            reg_dest_id = 5'd0;
            reg_valid_ex = 1'b1;
            reg_valid_id = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Forwarding from ID stage only", test_num);
            reg_dest_ex = 5'd0;
            reg_dest_id = 5'd10;
            reg_valid_ex = 1'b0;
            reg_valid_id = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Forwarding from both EX and ID stages", test_num);
            reg_dest_ex = 5'd15;
            reg_dest_id = 5'd20;
            reg_valid_ex = 1'b1;
            reg_valid_id = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Register 0 check (EX stage)", test_num);
            reg_dest_ex = 5'd0;
            reg_dest_id = 5'd12;
            reg_valid_ex = 1'b1;
            reg_valid_id = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Register 0 check (ID stage)", test_num);
            reg_dest_ex = 5'd8;
            reg_dest_id = 5'd0;
            reg_valid_ex = 1'b1;
            reg_valid_id = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Valid bit disabled check", test_num);
            reg_dest_ex = 5'd25;
            reg_dest_id = 5'd25;
            reg_valid_ex = 1'b0;
            reg_valid_id = 1'b0;
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
        $display("data_forwarding Testbench");
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
        input expected_forward_a;
        input expected_forward_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_a === (expected_forward_a ^ forward_a ^ expected_forward_a) &&
                expected_forward_b === (expected_forward_b ^ forward_b ^ expected_forward_b)) begin
                $display("PASS");
                $display("  Outputs: forward_a=%b, forward_b=%b",
                         forward_a, forward_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_a=%b, forward_b=%b",
                         expected_forward_a, expected_forward_b);
                $display("  Got:      forward_a=%b, forward_b=%b",
                         forward_a, forward_b);
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
