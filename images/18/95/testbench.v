`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [2:0] ALUOp;
    reg [7:0] B;
    wire [7:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUOp(ALUOp),
        .B(B),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: AND Operation (000)", test_num);
            A = 8'hAA;
            B = 8'hF0;
            ALUOp = 3'b000;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: OR Operation (001)", test_num);
            A = 8'h55;
            B = 8'h0F;
            ALUOp = 3'b001;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: XOR Operation (010)", test_num);
            A = 8'hFF;
            B = 8'hAA;
            ALUOp = 3'b010;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: ADD Operation (011)", test_num);
            A = 8'd25;
            B = 8'd10;
            ALUOp = 3'b011;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: ADD Overflow Check (011)", test_num);
            A = 8'hFF;
            B = 8'h01;
            ALUOp = 3'b011;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: SUBTRACT Operation (100)", test_num);
            A = 8'd50;
            B = 8'd20;
            ALUOp = 3'b100;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: SUBTRACT Underflow Check (100)", test_num);
            A = 8'd0;
            B = 8'd1;
            ALUOp = 3'b100;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: SLT True (101)", test_num);
            A = 8'd10;
            B = 8'd20;
            ALUOp = 3'b101;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: SLT False (101)", test_num);
            A = 8'd20;
            B = 8'd10;
            ALUOp = 3'b101;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: NOR Operation (110)", test_num);
            A = 8'h0F;
            B = 8'hF0;
            ALUOp = 3'b110;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("\nTestcase %0d: NAND Operation (111)", test_num);
            A = 8'hAA;
            B = 8'h55;
            ALUOp = 3'b111;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("\nTestcase %0d: SLT Equality Check (101)", test_num);
            A = 8'd15;
            B = 8'd15;
            ALUOp = 3'b101;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
