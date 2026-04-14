`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] a;
    reg [12:0] b;
    reg [4:0] op;
    wire [12:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'sd500; b = 13'sd1200; op = 5'b00000;
        $display("Testcase001: Addition (500 + 1200)");
        #1;

        check_outputs(13'sd1700);
    end
        endtask

    task testcase002;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = -13'sd100; b = -13'sd250; op = 5'b00000;
        $display("Testcase002: Addition (-100 + -250)");
        #1;

        check_outputs(-13'sd350);
    end
        endtask

    task testcase003;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'sd300; b = 13'sd800; op = 5'b00001;
        $display("Testcase003: Subtraction (300 - 800)");
        #1;

        check_outputs(-13'sd500);
    end
        endtask

    task testcase004;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = -13'sd50; b = 13'sd50; op = 5'b00001;
        $display("Testcase004: Subtraction (-50 - 50)");
        #1;

        check_outputs(-13'sd100);
    end
        endtask

    task testcase005;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'h0F0F; b = 13'h1555; op = 5'b00010;
        $display("Testcase005: Bitwise AND (13'h0F0F & 13'h1555)");
        #1;

        check_outputs(13'h0505);
    end
        endtask

    task testcase006;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'h0F0F; b = 13'h1555; op = 5'b00011;
        $display("Testcase006: Bitwise OR (13'h0F0F | 13'h1555)");
        #1;

        check_outputs(13'h1F5F);
    end
        endtask

    task testcase007;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'h1AAA; b = 13'h1555; op = 5'b00100;
        $display("Testcase007: Bitwise XOR (13'h1AAA ^ 13'h1555)");
        #1;

        check_outputs(13'h0FFF);
    end
        endtask

    task testcase008;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'sd7; b = 13'sd3; op = 5'b00101;
        $display("Testcase008: Shift Left (7 << 3)");
        #1;

        check_outputs(13'sd56);
    end
        endtask

    task testcase009;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = -13'sd1; b = 13'sd4; op = 5'b00101;
        $display("Testcase009: Shift Left (-1 << 4)");
        #1;

        check_outputs(-13'sd16);
    end
        endtask

    task testcase010;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = 13'sd1024; b = 13'sd5; op = 5'b00110;
        $display("Testcase010: Shift Right (1024 >> 5)");
        #1;

        check_outputs(13'sd32);
    end
        endtask

    task testcase011;

    begin
        a = 0; b = 0; op = 0;
        #5;
        a = -13'sd64; b = 13'sd3; op = 5'b00110;
        $display("Testcase011: Shift Right (-64 >> 3)");
        #1;

        check_outputs(-13'sd8);
    end
        endtask

    task testcase012;

    begin
        a = 0; b = 0; op = 0;
        #5;

        a = 13'sd10; b = 13'sd9; op = 5'b00101;
        $display("Testcase012: Shift Left (10 << (9 & 7))");
        #1;

        check_outputs(13'sd20);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [12:0] expected_result;
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
