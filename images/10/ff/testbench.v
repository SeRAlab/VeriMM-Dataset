`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [2:0] ALU_ctrl;
    reg [15:0] B;
    wire [15:0] ALU_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .ALU_ctrl(ALU_ctrl),
        .B(B),
        .ALU_out(ALU_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h1111;
            ALU_ctrl = 3'b000;
            $display("Test %0d: Addition (0x1234 + 0x1111)", test_num);
            #1;

            check_outputs(16'h2345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h0001;
            ALU_ctrl = 3'b000;
            $display("Test %0d: Addition Wrap (0xFFFF + 0x0001)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 16'h0020;
            B = 16'h0005;
            ALU_ctrl = 3'b001;
            $display("Test %0d: Subtraction (0x0020 - 0x0005)", test_num);
            #1;

            check_outputs(16'h001B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'h0001;
            ALU_ctrl = 3'b001;
            $display("Test %0d: Subtraction Wrap (0x0000 - 0x0001)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 16'hF0F0;
            B = 16'hAAAA;
            ALU_ctrl = 3'b010;
            $display("Test %0d: Bitwise AND (0xF0F0 & 0xAAAA)", test_num);
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'hFFFF;
            ALU_ctrl = 3'b010;
            $display("Test %0d: Bitwise AND (0x0000 & 0xFFFF)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 16'hF0F0;
            B = 16'hAAAA;
            ALU_ctrl = 3'b011;
            $display("Test %0d: Bitwise OR (0xF0F0 | 0xAAAA)", test_num);
            #1;

            check_outputs(16'hFAFA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 16'h5555;
            B = 16'hAAAA;
            ALU_ctrl = 3'b011;
            $display("Test %0d: Bitwise OR (0x5555 | 0xAAAA)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h1234;
            ALU_ctrl = 3'b100;
            $display("Test %0d: Bitwise XOR (0xFFFF ^ 0x1234)", test_num);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h1234;
            ALU_ctrl = 3'b100;
            $display("Test %0d: Bitwise XOR Identical (0x1234 ^ 0x1234)", test_num);
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
        input [15:0] expected_ALU_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h",
                         ALU_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h",
                         expected_ALU_out);
                $display("  Got:      ALU_out=%h",
                         ALU_out);
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
