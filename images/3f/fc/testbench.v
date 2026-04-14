`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALUControl;
    reg [31:0] B;
    wire [31:0] ALUResult;
    wire CarryOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUControl(ALUControl),
        .B(B),
        .ALUResult(ALUResult),
        .CarryOut(CarryOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (10 + 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            ALUControl = 3'b000;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry (Max + 1)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            ALUControl = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (50 - 20)", test_num);
            A = 32'd50;
            B = 32'd20;
            ALUControl = 3'b001;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Borrow (10 - 20)", test_num);
            A = 32'd10;
            B = 32'd20;
            ALUControl = 3'b001;

            #1;


            check_outputs(32'hFFF_FFF_F6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'hFFFF_0000;
            ALUControl = 3'b010;
            #1;

            check_outputs(32'hAAAA_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise OR", test_num);
            A = 32'h1234_0000;
            B = 32'h0000_5678;
            ALUControl = 3'b011;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h1234_5678;
            ALUControl = 3'b100;
            #1;

            check_outputs(32'hEDCB_A987, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Addition", test_num);
            A = 32'h8000_0000;
            B = 32'h8000_0000;
            ALUControl = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Resulting in Zero", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            ALUControl = 3'b001;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND with Zero", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0000;
            ALUControl = 3'b010;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
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
        input [31:0] expected_ALUResult;
        input expected_CarryOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUResult === (expected_ALUResult ^ ALUResult ^ expected_ALUResult) &&
                expected_CarryOut === (expected_CarryOut ^ CarryOut ^ expected_CarryOut)) begin
                $display("PASS");
                $display("  Outputs: ALUResult=%h, CarryOut=%b",
                         ALUResult, CarryOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUResult=%h, CarryOut=%b",
                         expected_ALUResult, expected_CarryOut);
                $display("  Got:      ALUResult=%h, CarryOut=%b",
                         ALUResult, CarryOut);
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
