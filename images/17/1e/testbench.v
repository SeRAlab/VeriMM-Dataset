`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [2:0] ALUCtrl;
    reg [7:0] B;
    wire [7:0] Result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUCtrl(ALUCtrl),
        .B(B),
        .Result(Result),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (15 + 10)", test_num);
            A = 8'd15; B = 8'd10; ALUCtrl = 3'b000;
            #1;

            check_outputs(8'd25, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (0 + 0)", test_num);
            A = 8'd0; B = 8'd0; ALUCtrl = 3'b000;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (50 - 20)", test_num);
            A = 8'd50; B = 8'd20; ALUCtrl = 3'b001;
            #1;

            check_outputs(8'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (100 - 100)", test_num);
            A = 8'd100; B = 8'd100; ALUCtrl = 3'b001;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND (0xF0 & 0xCC)", test_num);
            A = 8'hF0; B = 8'hCC; ALUCtrl = 3'b010;
            #1;

            check_outputs(8'hC0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise OR (0xAA | 0x55)", test_num);
            A = 8'hAA; B = 8'h55; ALUCtrl = 3'b011;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR (0xFF ^ 0x0F)", test_num);
            A = 8'hFF; B = 8'h0F; ALUCtrl = 3'b100;
            #1;

            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift (0x01 << 1)", test_num);
            A = 8'h01; B = 8'h00; ALUCtrl = 3'b101;
            #1;

            check_outputs(8'h02, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Shift (0x80 << 1)", test_num);
            A = 8'h80; B = 8'h00; ALUCtrl = 3'b101;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Shift (0x80 >> 1)", test_num);
            A = 8'h80; B = 8'h00; ALUCtrl = 3'b110;
            #1;

            check_outputs(8'h40, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise NOT (~0x55)", test_num);
            A = 8'h55; B = 8'h00; ALUCtrl = 3'b111;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise NOT (~0xFF)", test_num);
            A = 8'hFF; B = 8'h00; ALUCtrl = 3'b111;
            #1;

            check_outputs(8'h00, 1'b1);
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
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Result=%h, Zero=%b",
                         Result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h, Zero=%b",
                         expected_Result, expected_Zero);
                $display("  Got:      Result=%h, Zero=%b",
                         Result, Zero);
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
