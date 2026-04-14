`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] control;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_32bit dut (
        .A(A),
        .B(B),
        .control(control),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);
            A = 32'h0000_000A;
            B = 32'h0000_0014;
            control = 3'b000;
            #1;

            check_outputs(1'b0, 32'h0000_001E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Positive Overflow", test_num);
            A = 32'h7FFF_FFFF;
            B = 32'h0000_0001;
            control = 3'b000;
            #1;

            check_outputs(1'b1, 32'h8000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Negative Overflow", test_num);
            A = 32'h8000_0000;
            B = 32'hFFFF_FFFF;
            control = 3'b000;
            #1;

            check_outputs(1'b1, 32'h7FFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction", test_num);
            A = 32'h0000_0064;
            B = 32'h0000_0032;
            control = 3'b001;
            #1;

            check_outputs(1'b0, 32'h0000_0032);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Positive Overflow", test_num);
            A = 32'h7FFF_FFFF;
            B = 32'hFFFF_FFFF;
            control = 3'b001;
            #1;

            check_outputs(1'b1, 32'h8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Negative Overflow", test_num);
            A = 32'h8000_0000;
            B = 32'h0000_0001;
            control = 3'b001;
            #1;

            check_outputs(1'b1, 32'h7FFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 32'hF0F0_AAAA;
            B = 32'h0F0F_FFFF;
            control = 3'b010;
            #1;

            check_outputs(1'b0, 32'h0000_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 32'hF0F0_0000;
            B = 32'h0000_AAAA;
            control = 3'b011;
            #1;

            check_outputs(1'b0, 32'hF0F0_AAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            control = 3'b100;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR Identity (A ^ A)", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            control = 3'b100;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_32bit Testbench");
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
        input expected_overflow;
        input [31:0] expected_result;
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
