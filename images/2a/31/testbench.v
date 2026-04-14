`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest1;
    reg [4:0] dest2;
    reg [4:0] src1;
    reg [4:0] src2;
    reg valid1;
    reg valid2;
    wire forwardA;
    wire forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest1(dest1),
        .dest2(dest2),
        .src1(src1),
        .src2(src2),
        .valid1(valid1),
        .valid2(valid2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: No dependencies", test_num);
        src1 = 5'd1;
        src2 = 5'd2;
        dest1 = 5'd3;
        dest2 = 5'd4;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: src1 matches dest1", test_num);
        src1 = 5'd10;
        src2 = 5'd11;
        dest1 = 5'd10;
        dest2 = 5'd12;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: src2 matches dest1", test_num);
        src1 = 5'd5;
        src2 = 5'd6;
        dest1 = 5'd6;
        dest2 = 5'd7;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: src1 matches dest2", test_num);
        src1 = 5'd15;
        src2 = 5'd16;
        dest1 = 5'd17;
        dest2 = 5'd15;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: src2 matches dest2", test_num);
        src1 = 5'd20;
        src2 = 5'd21;
        dest1 = 5'd22;
        dest2 = 5'd21;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Priority check (src1 matches both stages)", test_num);
        src1 = 5'd8;
        src2 = 5'd9;
        dest1 = 5'd8;
        dest2 = 5'd8;
        valid1 = 1'b1;
        valid2 = 1'b1;

        #1;


        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Register 0 check", test_num);
        src1 = 5'd0;
        src2 = 5'd0;
        dest1 = 5'd0;
        dest2 = 5'd0;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Valid signal check", test_num);
        src1 = 5'd4;
        src2 = 5'd5;
        dest1 = 5'd4;
        dest2 = 5'd5;
        valid1 = 1'b0;
        valid2 = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mixed forwarding sources", test_num);
        src1 = 5'd25;
        src2 = 5'd26;
        dest1 = 5'd26;
        dest2 = 5'd25;
        valid1 = 1'b1;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Only stage 2 is valid", test_num);
        src1 = 5'd12;
        src2 = 5'd12;
        dest1 = 5'd12;
        dest2 = 5'd12;
        valid1 = 1'b0;
        valid2 = 1'b1;
        #1;

        check_outputs(2'b10, 2'b10);
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
        input expected_forwardA;
        input expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%b, forwardB=%b",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%b, forwardB=%b",
                         forwardA, forwardB);
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
