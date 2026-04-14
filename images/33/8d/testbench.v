`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_reg;
    reg reg_write;
    reg [4:0] src_reg1;
    reg [4:0] src_reg2;
    wire forward1;
    wire forward2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest_reg(dest_reg),
        .reg_write(reg_write),
        .src_reg1(src_reg1),
        .src_reg2(src_reg2),
        .forward1(forward1),
        .forward2(forward2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No forwarding - registers do not match", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd10;
            src_reg1 = 5'd1;
            src_reg2 = 5'd2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding to source register 1", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd15;
            src_reg1 = 5'd15;
            src_reg2 = 5'd2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding to source register 2", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd20;
            src_reg1 = 5'd1;
            src_reg2 = 5'd20;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding to both source registers", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd25;
            src_reg1 = 5'd25;
            src_reg2 = 5'd25;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No forwarding when reg_write is 0", test_num);
            reg_write = 1'b0;
            dest_reg = 5'd12;
            src_reg1 = 5'd12;
            src_reg2 = 5'd12;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No forwarding when destination is register 0", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd0;
            src_reg1 = 5'd0;
            src_reg2 = 5'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed match (src1 matches, src2 different)", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd5;
            src_reg1 = 5'd5;
            src_reg2 = 5'd6;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed match (src1 different, src2 matches)", test_num);
            reg_write = 1'b1;
            dest_reg = 5'd31;
            src_reg1 = 5'd30;
            src_reg2 = 5'd31;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_forward1;
        input expected_forward2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward1 === (expected_forward1 ^ forward1 ^ expected_forward1) &&
                expected_forward2 === (expected_forward2 ^ forward2 ^ expected_forward2)) begin
                $display("PASS");
                $display("  Outputs: forward1=%b, forward2=%b",
                         forward1, forward2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward1=%b, forward2=%b",
                         expected_forward1, expected_forward2);
                $display("  Got:      forward1=%b, forward2=%b",
                         forward1, forward2);
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
