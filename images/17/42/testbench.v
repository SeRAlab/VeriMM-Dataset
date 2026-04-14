`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'h1234;
            B = 16'h1111;
            opcode = 4'b0000;
            $display("Test %0d: Opcode ADD (Basic)", test_num);
            #1;

            check_outputs(16'h2345);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'hFFFF;
            B = 16'h0001;
            opcode = 4'b0000;
            $display("Test %0d: Opcode ADD (Overflow wrap)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'h4444;
            B = 16'h1111;
            opcode = 4'b0001;
            $display("Test %0d: Opcode SUB (Basic)", test_num);
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'h0000;
            B = 16'h0001;
            opcode = 4'b0001;
            $display("Test %0d: Opcode SUB (Underflow wrap)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'hF0F0;
            B = 16'hAAAA;
            opcode = 4'b0010;
            $display("Test %0d: Opcode AND", test_num);
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'hF0F0;
            B = 16'h0F0F;
            opcode = 4'b0011;
            $display("Test %0d: Opcode OR", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'hABCD;
            B = 16'hABCD;
            opcode = 4'b0100;
            $display("Test %0d: Opcode XOR (Self)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'h1234;
            B = 16'hFFFF;
            opcode = 4'b0100;
            $display("Test %0d: Opcode XOR (Complement)", test_num);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 16'h7FFF;
            B = 16'h0001;
            opcode = 4'b0000;
            $display("Test %0d: Opcode ADD (Boundary)", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 16'h0000;
            B = 16'h0000;
            opcode = 4'b0010;
            $display("Test %0d: Opcode AND (Zeros)", test_num);
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
