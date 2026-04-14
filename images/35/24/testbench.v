`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] opcode;
    wire [31:0] OUT;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .OUT(OUT),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'd15;
            B = 32'd25;
            opcode = 3'b000;
            $display("Test %0d: Addition (15 + 25)", test_num);
            #1;

            check_outputs(32'd40, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            opcode = 3'b000;
            $display("Test %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'd100;
            B = 32'd40;
            opcode = 3'b001;
            $display("Test %0d: Subtraction (100 - 40)", test_num);
            #1;

            check_outputs(32'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'hABC_1234;
            B = 32'hABC_1234;
            opcode = 3'b001;
            $display("Test %0d: Subtraction to Zero", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'hF0F0_AAAA;
            B = 32'h0F0F_FFFF;
            opcode = 3'b010;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'h0000_AAAA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'hF0F0_0000;
            B = 32'h0000_AAAA;
            opcode = 3'b011;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hF0F0_AAAA, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h5555_5555;
            B = 32'h5555_5555;
            opcode = 3'b100;
            $display("Test %0d: Bitwise XOR (Self)", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h0000_0001;
            B = 32'd4;
            opcode = 3'b101;
            $display("Test %0d: Logical Shift Left (1 << 4)", test_num);
            #1;

            check_outputs(32'h0000_0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'h8000_0000;
            B = 32'd1;
            opcode = 3'b110;
            $display("Test %0d: Logical Shift Right (MSB move)", test_num);
            #1;

            check_outputs(32'h4000_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            opcode = 3'b111;
            $display("Test %0d: SLT (-1 < 1)", test_num);

            #1;


            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 32'd50;
            B = 32'd10;
            opcode = 3'b111;
            $display("Test %0d: SLT (50 < 10)", test_num);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A = 32'hFFFF_FFFF;
            B = 32'd32;
            opcode = 3'b101;
            $display("Test %0d: LSL (Shift Out All)", test_num);


            #1;



            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_OUT;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, Z=%b",
                         OUT, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, Z=%b",
                         expected_OUT, expected_Z);
                $display("  Got:      OUT=%h, Z=%b",
                         OUT, Z);
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
