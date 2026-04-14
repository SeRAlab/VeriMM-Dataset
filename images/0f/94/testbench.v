`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [2:0] ALU_Sel;
    reg [31:0] B;
    wire [31:0] ALU_Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_Sel(ALU_Sel),
        .B(B),
        .ALU_Result(ALU_Result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'd15;
            B = 32'd25;
            ALU_Sel = 3'b000;
            $display("Test %0d: Addition (15 + 25)", test_num);
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            ALU_Sel = 3'b000;
            $display("Test %0d: Addition with Overflow (0xFFFFFFFF + 1)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'd50;
            B = 32'd20;
            ALU_Sel = 3'b001;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'd10;
            B = 32'd20;
            ALU_Sel = 3'b001;
            $display("Test %0d: Subtraction resulting in negative (10 - 20)", test_num);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'hAAAA_AAAA;
            B = 32'hF0F0_F0F0;
            ALU_Sel = 3'b010;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hA0A0_A0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            ALU_Sel = 3'b011;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            ALU_Sel = 3'b100;
            $display("Test %0d: Bitwise XOR (Same values)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            ALU_Sel = 3'b100;
            $display("Test %0d: Bitwise XOR (Different values)", test_num);
            #1;

            check_outputs(32'h9551_1559);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'd10;
            B = 32'd20;
            ALU_Sel = 3'b101;
            $display("Test %0d: SLT (10 < 20)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'd20;
            B = 32'd10;
            ALU_Sel = 3'b101;
            $display("Test %0d: SLT (20 < 10)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            ALU_Sel = 3'b101;
            $display("Test %0d: SLT signed check (-1 < 1)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A = 32'd50;
            B = 32'd50;
            ALU_Sel = 3'b101;
            $display("Test %0d: SLT equality check (50 < 50)", test_num);
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_ALU_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_Result === (expected_ALU_Result ^ ALU_Result ^ expected_ALU_Result)) begin
                $display("PASS");
                $display("  Outputs: ALU_Result=%h",
                         ALU_Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Result=%h",
                         expected_ALU_Result);
                $display("  Got:      ALU_Result=%h",
                         ALU_Result);
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
