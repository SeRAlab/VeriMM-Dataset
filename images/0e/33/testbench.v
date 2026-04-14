`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dst1;
    reg [4:0] dst2;
    reg [4:0] src1;
    reg [4:0] src2;
    reg write_enable;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dst1(dst1),
        .dst2(dst2),
        .src1(src1),
        .src2(src2),
        .write_enable(write_enable),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No Matching Registers", test_num);
        src1 = 5'd1; src2 = 5'd2;
        dst1 = 5'd3; dst2 = 5'd4;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward src1 from dst1", test_num);
        src1 = 5'd10; src2 = 5'd5;
        dst1 = 5'd10; dst2 = 5'd20;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward src1 from dst2", test_num);
        src1 = 5'd15; src2 = 5'd5;
        dst1 = 5'd10; dst2 = 5'd15;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward src2 from dst1", test_num);
        src1 = 5'd1; src2 = 5'd2;
        dst1 = 5'd2; dst2 = 5'd3;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Forward src2 from dst2", test_num);
        src1 = 5'd1; src2 = 5'd2;
        dst1 = 5'd4; dst2 = 5'd2;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write Enable Off (No Forwarding)", test_num);
        src1 = 5'd7; src2 = 5'd8;
        dst1 = 5'd7; dst2 = 5'd8;
        write_enable = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simultaneous Forwarding (A from dst1, B from dst2)", test_num);
        src1 = 5'd11; src2 = 5'd12;
        dst1 = 5'd11; dst2 = 5'd12;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both Sources Match dst1", test_num);
        src1 = 5'd25; src2 = 5'd25;
        dst1 = 5'd25; dst2 = 5'd0;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: src1 matches both dst1 and dst2 (Invalid Case 11)", test_num);
        src1 = 5'd30; src2 = 5'd1;
        dst1 = 5'd30; dst2 = 5'd30;
        write_enable = 1'b1;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both Sources Match dst2", test_num);
        src1 = 5'd14; src2 = 5'd14;
        dst1 = 5'd2;  dst2 = 5'd14;
        write_enable = 1'b1;
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
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%h, forwardB=%h",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%h, forwardB=%h",
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
