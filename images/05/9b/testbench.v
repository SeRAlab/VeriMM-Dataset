`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] op;
    wire CarryOut;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .op(op),
        .CarryOut(CarryOut),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: AND Operation", test_num);
            A = 16'hAAAA;
            B = 16'hFFFF;
            op = 3'b000;
            #1;

            check_outputs(1'b0, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: OR Operation", test_num);
            A = 16'h1234;
            B = 16'h8765;
            op = 3'b001;
            #1;

            check_outputs(1'b0, 16'h9775);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR Operation", test_num);
            A = 16'hF0F0;
            B = 16'hAAAA;
            op = 3'b010;
            #1;

            check_outputs(1'b0, 16'h5A5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD Operation (No Carry)", test_num);
            A = 16'h1000;
            B = 16'h2000;
            op = 3'b011;
            #1;

            check_outputs(1'b0, 16'h3000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ADD Operation (With CarryOut)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            op = 3'b011;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUBTRACT Operation (No Borrow)", test_num);
            A = 16'h0010;
            B = 16'h0005;
            op = 3'b100;
            #1;

            check_outputs(1'b0, 16'h000B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SUBTRACT Operation (With Borrow/Carry)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            op = 3'b100;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NAND Operation", test_num);
            A = 16'hF0F0;
            B = 16'h0F0F;
            op = 3'b101;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: NOR Operation", test_num);
            A = 16'h0000;
            B = 16'h0000;
            op = 3'b110;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XNOR Operation", test_num);
            A = 16'hAAAA;
            B = 16'hAAAA;
            op = 3'b111;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme Values ADD", test_num);
            A = 16'h8000;
            B = 16'h8000;
            op = 3'b011;
            #1;

            check_outputs(1'b1, 16'h0000);
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
        input expected_CarryOut;
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CarryOut === (expected_CarryOut ^ CarryOut ^ expected_CarryOut) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: CarryOut=%b, Result=%h",
                         CarryOut, Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CarryOut=%b, Result=%h",
                         expected_CarryOut, expected_Result);
                $display("  Got:      CarryOut=%b, Result=%h",
                         CarryOut, Result);
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
