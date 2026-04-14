`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [3:0] ALU_control;
    reg [31:0] B;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Addition (5 + 10)", test_num);
        A = 32'd5;
        B = 32'd10;
        ALU_control = 4'h0;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Addition Wrap-around (MAX + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        ALU_control = 4'h0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Subtraction (20 - 5)", test_num);
        A = 32'd20;
        B = 32'd5;
        ALU_control = 4'h1;
        #1;

        check_outputs(32'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Subtraction (5 - 10)", test_num);
        A = 32'd5;
        B = 32'd10;
        ALU_control = 4'h1;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Bitwise AND (0xAAAA_AAAA & 0xFFFF_0000)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'hFFFF0000;
        ALU_control = 4'h2;
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Bitwise AND (Zero result)", test_num);
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALU_control = 4'h2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Bitwise OR (0x5555_5555 | 0xAAAA_AAAA)", test_num);
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        ALU_control = 4'h3;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Bitwise OR (Identity check)", test_num);
        A = 32'h12345678;
        B = 32'h00000000;
        ALU_control = 4'h3;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Addition with Zero", test_num);
        A = 32'hDEADBEEF;
        B = 32'h00000000;
        ALU_control = 4'h0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Subtraction (X - X = 0)", test_num);
        A = 32'hCAFEBABE;
        B = 32'hCAFEBABE;
        ALU_control = 4'h1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
