`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_control;
    reg [31:0] B;
    wire [31:0] ALU_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (10 + 20)", test_num);
        A = 32'd10;
        B = 32'd20;
        ALU_control = 3'b000;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Overflow handling check)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALU_control = 3'b000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        A = 32'd50;
        B = 32'd20;
        ALU_control = 3'b001;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Result Negative)", test_num);
        A = 32'd10;
        B = 32'd20;
        ALU_control = 3'b001;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hAAAA5555;
        ALU_control = 3'b010;
        #1;

        check_outputs(32'hA0A05050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALU_control = 3'b011;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        ALU_control = 3'b100;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Shift Left (1 << 4)", test_num);
        A = 32'h00000001;
        B = 32'd4;
        ALU_control = 3'b101;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Shift Right (0x80 >> 4)", test_num);
        A = 32'h00000080;
        B = 32'd4;
        ALU_control = 3'b110;
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (True: 5 < 10)", test_num);
        A = 32'd5;
        B = 32'd10;
        ALU_control = 3'b111;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (False: 10 < 5)", test_num);
        A = 32'd10;
        B = 32'd5;
        ALU_control = 3'b111;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SLT (Signed check: -1 < 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALU_control = 3'b111;
        #1;

        check_outputs(32'h00000001);
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
        input [31:0] expected_ALU_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h",
                         ALU_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h",
                         expected_ALU_result);
                $display("  Got:      ALU_result=%h",
                         ALU_result);
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
