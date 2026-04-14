`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest_reg1;
    reg [4:0] dest_reg2;
    reg reg_write1;
    reg reg_write2;
    reg [4:0] src_reg1;
    reg [4:0] src_reg2;
    wire forward_a;
    wire forward_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest_reg1(dest_reg1),
        .dest_reg2(dest_reg2),
        .reg_write1(reg_write1),
        .reg_write2(reg_write2),
        .src_reg1(src_reg1),
        .src_reg2(src_reg2),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No forwarding needed", test_num);
            src_reg1 = 5'd1;
            src_reg2 = 5'd2;
            dest_reg1 = 5'd3;
            dest_reg2 = 5'd4;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Forward A from dest_reg1", test_num);
            src_reg1 = 5'd10;
            src_reg2 = 5'd11;
            dest_reg1 = 5'd10;
            dest_reg2 = 5'd12;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Forward B from dest_reg1", test_num);
            src_reg1 = 5'd5;
            src_reg2 = 5'd6;
            dest_reg1 = 5'd6;
            dest_reg2 = 5'd7;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Forward A from dest_reg2", test_num);
            src_reg1 = 5'd15;
            src_reg2 = 5'd16;
            dest_reg1 = 5'd20;
            dest_reg2 = 5'd15;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Forward B from dest_reg2", test_num);
            src_reg1 = 5'd1;
            src_reg2 = 5'd2;
            dest_reg1 = 5'd3;
            dest_reg2 = 5'd2;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No Forwarding if reg_write1 is 0", test_num);
            src_reg1 = 5'd8;
            src_reg2 = 5'd9;
            dest_reg1 = 5'd8;
            dest_reg2 = 5'd10;
            reg_write1 = 1'b0;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No Forwarding if reg_write2 is 0", test_num);
            src_reg1 = 5'd22;
            src_reg2 = 5'd23;
            dest_reg1 = 5'd25;
            dest_reg2 = 5'd23;
            reg_write1 = 1'b1;
            reg_write2 = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: No Forwarding for Register 0", test_num);
            src_reg1 = 5'd0;
            src_reg2 = 5'd0;
            dest_reg1 = 5'd0;
            dest_reg2 = 5'd0;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Forward A from stage 1, B from stage 2", test_num);
            src_reg1 = 5'd4;
            src_reg2 = 5'd5;
            dest_reg1 = 5'd4;
            dest_reg2 = 5'd5;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Priority check - match both dest stages", test_num);
            src_reg1 = 5'd18;
            src_reg2 = 5'd31;
            dest_reg1 = 5'd18;
            dest_reg2 = 5'd18;
            reg_write1 = 1'b1;
            reg_write2 = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
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
