`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [2:0] ALUControl;
    reg [7:0] B;
    wire Overflow;
    wire [7:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .ALUControl(ALUControl),
        .B(B),
        .Overflow(Overflow),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD (No Overflow) - 10 + 20", test_num);
            A = 8'd10;
            B = 8'd20;
            ALUControl = 3'b000;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD (Positive Overflow) - 120 + 10", test_num);
            A = 8'd120;
            B = 8'd10;
            ALUControl = 3'b000;
            #1;

            check_outputs(1'b1, 8'h82);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD (Negative Overflow) - (-120) + (-10)", test_num);
            A = 8'h88;
            B = 8'hf6;
            ALUControl = 3'b000;
            #1;

            check_outputs(1'b1, 8'h7E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB (No Overflow) - 50 - 20", test_num);
            A = 8'd50;
            B = 8'd20;
            ALUControl = 3'b001;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB (Overflow) - 100 - (-50)", test_num);
            A = 8'd100;
            B = 8'b11001110;
            ALUControl = 3'b001;
            #1;

            check_outputs(1'b1, 8'h96);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND - 0xAA & 0xF0", test_num);
            A = 8'hAA;
            B = 8'hF0;
            ALUControl = 3'b010;
            #1;

            check_outputs(1'b0, 8'hA0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR - 0x55 | 0x0F", test_num);
            A = 8'h55;
            B = 8'h0F;
            ALUControl = 3'b011;
            #1;

            check_outputs(1'b0, 8'h5F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR - 0xFF ^ 0xAA", test_num);
            A = 8'hFF;
            B = 8'hAA;
            ALUControl = 3'b100;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NAND - ~(0xF0 & 0x0F)", test_num);
            A = 8'hF0;
            B = 8'h0F;
            ALUControl = 3'b101;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOR - ~(0x01 | 0x02)", test_num);
            A = 8'h01;
            B = 8'h02;
            ALUControl = 3'b110;
            #1;

            check_outputs(1'b0, 8'hFC);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOT - ~0x55 (B ignored)", test_num);
            A = 8'h55;
            B = 8'hFF;
            ALUControl = 3'b111;
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUB (Zero Result) - 128 - 128", test_num);
            A = 8'h80;
            B = 8'h80;
            ALUControl = 3'b001;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_8bit Testbench");
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
        input expected_Overflow;
        input [7:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Result=%h",
                         Overflow, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Result=%h",
                         expected_Overflow, expected_Result);
                $display("  Got:      Overflow=%b, Result=%h",
                         Overflow, Result);
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
