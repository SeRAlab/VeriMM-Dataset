`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dst;
    reg forward_src1;
    reg forward_src2;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [4:0] out_src1;
    wire [4:0] out_src2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dst(dst),
        .forward_src1(forward_src1),
        .forward_src2(forward_src2),
        .src1(src1),
        .src2(src2),
        .out_src1(out_src1),
        .out_src2(out_src2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No forwarding", test_num);
            src1 = 5'd10;
            src2 = 5'd20;
            dst  = 5'd31;
            forward_src1 = 1'b0;
            forward_src2 = 1'b0;
            #1;

            check_outputs(5'd10, 5'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Forwarding Source 1", test_num);
            src1 = 5'd10;
            src2 = 5'd20;
            dst  = 5'd15;
            forward_src1 = 1'b1;
            forward_src2 = 1'b0;
            #1;

            check_outputs(5'd15, 5'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Forwarding Source 2", test_num);
            src1 = 5'd5;
            src2 = 5'd8;
            dst  = 5'd25;
            forward_src1 = 1'b0;
            forward_src2 = 1'b1;
            #1;

            check_outputs(5'd5, 5'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Forwarding Both Sources", test_num);
            src1 = 5'd2;
            src2 = 5'd4;
            dst  = 5'd12;
            forward_src1 = 1'b1;
            forward_src2 = 1'b1;
            #1;

            check_outputs(5'd12, 5'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Forwarding when src equals dst index", test_num);
            src1 = 5'd7;
            src2 = 5'd7;
            dst  = 5'd7;
            forward_src1 = 1'b1;
            forward_src2 = 1'b1;
            #1;

            check_outputs(5'd7, 5'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Zero Register Data", test_num);
            src1 = 5'd0;
            src2 = 5'd0;
            dst  = 5'd0;
            forward_src1 = 1'b0;
            forward_src2 = 1'b0;
            #1;

            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum 5-bit Values", test_num);
            src1 = 5'b11111;
            src2 = 5'b11111;
            dst  = 5'b01010;
            forward_src1 = 1'b1;
            forward_src2 = 1'b0;
            #1;

            check_outputs(5'b01010, 5'b11111);
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
        input [4:0] expected_out_src1;
        input [4:0] expected_out_src2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_src1 === (expected_out_src1 ^ out_src1 ^ expected_out_src1) &&
                expected_out_src2 === (expected_out_src2 ^ out_src2 ^ expected_out_src2)) begin
                $display("PASS");
                $display("  Outputs: out_src1=%h, out_src2=%h",
                         out_src1, out_src2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_src1=%h, out_src2=%h",
                         expected_out_src1, expected_out_src2);
                $display("  Got:      out_src1=%h, out_src2=%h",
                         out_src1, out_src2);
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
