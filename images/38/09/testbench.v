`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] opcode;
    wire overflow;
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
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD - Normal", test_num);
        A = 16'h0005; B = 16'h000A; opcode = 4'b0000;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADD - Signed Overflow", test_num);
        A = 16'h7FFF; B = 16'h0001; opcode = 4'b0000;
        #1;

        check_outputs(1'b1, 16'h8000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT - Normal", test_num);
        A = 16'h0014; B = 16'h0005; opcode = 4'b0001;
        #1;

        check_outputs(1'b0, 16'h000F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SUBTRACT - Signed Overflow", test_num);
        A = 16'h8000; B = 16'h0001; opcode = 4'b0001;
        #1;

        check_outputs(1'b1, 16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: AND", test_num);
        A = 16'hF0F0; B = 16'hAAAA; opcode = 4'b0010;
        #1;

        check_outputs(1'b0, 16'hA0A0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: OR", test_num);
        A = 16'hF0F0; B = 16'hAAAA; opcode = 4'b0011;
        #1;

        check_outputs(1'b0, 16'hFAFA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XOR", test_num);
        A = 16'hFFFF; B = 16'h1234; opcode = 4'b0100;
        #1;

        check_outputs(1'b0, 16'hEDCB);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOT (Input A)", test_num);
        A = 16'h00FF; B = 16'hFFFF; opcode = 4'b0101;
        #1;

        check_outputs(1'b0, 16'hFF00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NAND", test_num);
        A = 16'hF0F0; B = 16'h0F0F; opcode = 4'b0110;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: NOR", test_num);
        A = 16'h0000; B = 16'h0000; opcode = 4'b0111;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XNOR", test_num);
        A = 16'hAAAA; B = 16'hAAAA; opcode = 4'b1000;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SHIFT LEFT", test_num);
        A = 16'h0001; B = 16'h0000; opcode = 4'b1001;
        #1;

        check_outputs(1'b0, 16'h0002);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SHIFT RIGHT", test_num);
        A = 16'h0002; B = 16'h0000; opcode = 4'b1010;
        #1;

        check_outputs(1'b0, 16'h0001);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_overflow;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
