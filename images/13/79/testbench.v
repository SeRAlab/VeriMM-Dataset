`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [2:0] ALU_Sel;
    reg [63:0] B;
    wire [63:0] Result;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .ALU_Sel(ALU_Sel),
        .B(B),
        .Result(Result),
        .Zero(Zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition", test_num);
            A = 64'h0000_0000_0000_0005;
            B = 64'h0000_0000_0000_000A;
            ALU_Sel = 3'b000;
            #1;

            check_outputs(64'h0000_0000_0000_000F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition producing Zero (Overflow)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            ALU_Sel = 3'b000;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction", test_num);
            A = 64'h0000_0000_0000_0014;
            B = 64'h0000_0000_0000_0005;
            ALU_Sel = 3'b001;
            #1;

            check_outputs(64'h0000_0000_0000_000F, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Resulting in Zero", test_num);
            A = 64'hDEAD_BEEF_CAFE_BABE;
            B = 64'hDEAD_BEEF_CAFE_BABE;
            ALU_Sel = 3'b001;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 64'hF0F0_F0F0_F0F0_F0F0;
            B = 64'hAAAA_AAAA_AAAA_AAAA;
            ALU_Sel = 3'b010;
            #1;

            check_outputs(64'hA0A0_A0A0_A0A0_A0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 64'h1234_5678_1234_5678;
            B = 64'h8765_4321_8765_4321;
            ALU_Sel = 3'b011;
            #1;

            check_outputs(64'h9775_5779_9775_5779, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'h5555_5555_5555_5555;
            ALU_Sel = 3'b100;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR Resulting in Zero", test_num);
            A = 64'h1357_9BDF_2468_ACE0;
            B = 64'h1357_9BDF_2468_ACE0;
            ALU_Sel = 3'b100;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Wrap-around", test_num);
            A = 64'h0000_0000_0000_0000;
            B = 64'h0000_0000_0000_0001;
            ALU_Sel = 3'b001;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND Resulting in Zero", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'h5555_5555_5555_5555;
            ALU_Sel = 3'b010;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 1'b1);
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
        input [63:0] expected_Result;
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
