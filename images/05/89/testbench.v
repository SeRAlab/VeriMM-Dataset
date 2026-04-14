`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire [31:0] R;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .R(R),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (15 + 25)", test_num);
        A = 32'd15;
        B = 32'd25;
        opcode = 3'b000;
        #1;

        check_outputs(32'd40, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Max + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        opcode = 3'b000;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (100 - 30)", test_num);
        A = 32'd100;
        B = 32'd30;
        opcode = 3'b001;
        #1;

        check_outputs(32'd70, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (50 - 50)", test_num);
        A = 32'd50;
        B = 32'd50;
        opcode = 3'b001;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 32'hAAAA_5555;
        B = 32'hF0F0_F0F0;
        opcode = 3'b010;
        #1;

        check_outputs(32'hA0A0_5050, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 32'h1234_0000;
        B = 32'h0000_5678;
        opcode = 3'b011;
        #1;

        check_outputs(32'h1234_5678, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hF0F0_F0F0;
        opcode = 3'b100;
        #1;

        check_outputs(32'h0F0F_0F0F, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (5 < 10)", test_num);
        A = 32'd5;
        B = 32'd10;
        opcode = 3'b101;
        #1;

        check_outputs(32'h00000001, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (20 < 10)", test_num);
        A = 32'd20;
        B = 32'd10;
        opcode = 3'b101;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (7 < 7)", test_num);
        A = 32'd7;
        B = 32'd7;
        opcode = 3'b101;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR Zero Flag", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        opcode = 3'b100;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_R;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: R=%h, zero=%b",
                         R, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h, zero=%b",
                         expected_R, expected_zero);
                $display("  Got:      R=%h, zero=%b",
                         R, zero);
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
