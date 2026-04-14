`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] control;
    wire [15:0] R;
    wire flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .R(R),
        .flag(flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: ADD (5 + 3)", test_num);
        A = 16'd5;
        B = 16'd3;
        control = 4'b0000;
        #1;

        check_outputs(16'd8, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: SUBTRACT (10 - 4)", test_num);
        A = 16'd10;
        B = 16'd4;
        control = 4'b0001;
        #1;

        check_outputs(16'd6, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: AND (0xAAAA & 0x5555)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        control = 4'b0010;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: OR (0xF0F0 | 0x0F0F)", test_num);
        A = 16'hF0F0;
        B = 16'h0F0F;
        control = 4'b0011;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: XOR (0x1234 ^ 0x1234)", test_num);
        A = 16'h1234;
        B = 16'h1234;
        control = 4'b0100;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: NOT (~0x0000)", test_num);
        A = 16'h0000;
        B = 16'hFFFF;
        control = 4'b0101;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: SHIFT LEFT (0x0001 << 1)", test_num);
        A = 16'h0001;
        B = 16'h0001;
        control = 4'b0110;
        #1;

        check_outputs(16'h0002, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: SHIFT RIGHT (0x8000 >> 1)", test_num);
        A = 16'h8000;
        B = 16'h0001;
        control = 4'b0111;
        #1;

        check_outputs(16'h4000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: LESS THAN (5 < 10)", test_num);
        A = 16'd5;
        B = 16'd10;
        control = 4'b1000;
        #1;

        check_outputs(16'd1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: GREATER THAN (10 > 5)", test_num);
        A = 16'd10;
        B = 16'd5;
        control = 4'b1001;
        #1;

        check_outputs(16'd1, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: EQUAL (15 == 15)", test_num);
        A = 16'd15;
        B = 16'd15;
        control = 4'b1010;
        #1;

        check_outputs(16'd1, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: EQUAL (15 == 16)", test_num);
        A = 16'd15;
        B = 16'd16;
        control = 4'b1010;
        #1;

        check_outputs(16'd0, 1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: ADD Overflow (0xFFFF + 1)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        control = 4'b0000;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: SUB Underflow (0x0000 - 1)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        control = 4'b0001;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input [15:0] expected_R;
        input expected_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R) &&
                expected_flag === (expected_flag ^ flag ^ expected_flag)) begin
                $display("PASS");
                $display("  Outputs: R=%h, flag=%b",
                         R, flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h, flag=%b",
                         expected_R, expected_flag);
                $display("  Got:      R=%h, flag=%b",
                         R, flag);
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
