`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [2:0] opcode;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 64'd100;
        B = 64'd200;
        opcode = 3'b000;
        $display("Testcase %0d: Opcode ADD (100 + 200)", test_num);
        #1;

        check_outputs(64'd300);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        opcode = 3'b000;
        $display("Testcase %0d: Opcode ADD (Max + 1)", test_num);
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 64'd500;
        B = 64'd150;
        opcode = 3'b001;
        $display("Testcase %0d: Opcode SUB (500 - 150)", test_num);
        #1;

        check_outputs(64'd350);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 64'd10;
        B = 64'd20;
        opcode = 3'b001;
        $display("Testcase %0d: Opcode SUB (10 - 20)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 64'hAAAA_AAAA_AAAA_AAAA;
        B = 64'h5555_5555_5555_5555;
        opcode = 3'b010;
        $display("Testcase %0d: Opcode AND (Alternating bits)", test_num);
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 64'hFEDC_BA98_7654_3210;
        B = 64'hFFFF_FFFF_0000_0000;
        opcode = 3'b010;
        $display("Testcase %0d: Opcode AND (Upper word mask)", test_num);
        #1;

        check_outputs(64'hFEDC_BA98_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 64'hAAAA_AAAA_0000_0000;
        B = 64'h0000_0000_5555_5555;
        opcode = 3'b011;
        $display("Testcase %0d: Opcode OR (Combining halves)", test_num);
        #1;

        check_outputs(64'hAAAA_AAAA_5555_5555);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 64'hFFFF_0000_FFFF_0000;
        B = 64'h0000_FFFF_0000_FFFF;
        opcode = 3'b011;
        $display("Testcase %0d: Opcode OR (All ones result)", test_num);
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 64'h1234_5678_9ABC_DEF0;
        B = 64'h1234_5678_9ABC_DEF0;
        opcode = 3'b100;
        $display("Testcase %0d: Opcode XOR (Same value)", test_num);
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h1234_5678_9ABC_DEF0;
        opcode = 3'b100;
        $display("Testcase %0d: Opcode XOR (Inverting B)", test_num);
        #1;

        check_outputs(~64'h1234_5678_9ABC_DEF0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_64bit Testbench");
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
        input [63:0] expected_result;
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
