`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [2:0] ALU_control;
    reg [15:0] B;
    wire [15:0] ALU_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND operation (Basic)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        ALU_control = 3'b000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND operation (Identity)", test_num);
        A = 16'hFFFF;
        B = 16'h1234;
        ALU_control = 3'b000;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR operation (Basic)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        ALU_control = 3'b001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR operation (Masking)", test_num);
        A = 16'hF0F0;
        B = 16'h0F0F;
        ALU_control = 3'b001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD operation (Basic)", test_num);
        A = 16'h1234;
        B = 16'h1111;
        ALU_control = 3'b010;
        #1;

        check_outputs(16'h2345);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD operation (Carry/Overflow handling)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        ALU_control = 3'b010;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB operation (Basic)", test_num);
        A = 16'h5555;
        B = 16'h1111;
        ALU_control = 3'b011;
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUB operation (Negative result/Underflow)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        ALU_control = 3'b011;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (Inversion)", test_num);
        A = 16'hAAAA;
        B = 16'hFFFF;
        ALU_control = 3'b100;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR operation (Zero identity)", test_num);
        A = 16'hABCD;
        B = 16'hABCD;
        ALU_control = 3'b100;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
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
        input [15:0] expected_ALU_result;
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
