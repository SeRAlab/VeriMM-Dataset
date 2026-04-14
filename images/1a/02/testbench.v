`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive * Positive (7 * 3)", test_num);
        A = 8'sd7; B = 8'sd3;
        #1;

        check_outputs(16'sd21);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by Zero (0 * 15)", test_num);
        A = 8'sd0; B = 8'sd15;
        #1;

        check_outputs(16'sd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive * Negative (10 * -5)", test_num);
        A = 8'sd10; B = -8'sd5;
        #1;

        check_outputs(-16'sd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative * Positive (-12 * 4)", test_num);
        A = -8'sd12; B = 8'sd4;
        #1;

        check_outputs(-16'sd48);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative * Negative (-3 * -4)", test_num);
        A = -8'sd3; B = -8'sd4;
        #1;

        check_outputs(16'sd12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Positive (127 * 127)", test_num);
        A = 8'h7F; B = 8'h7F;
        #1;

        check_outputs(16'h3F01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Negative (-128 * -128)", test_num);
        A = 8'h80; B = 8'h80;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Min Neg * Max Pos (-128 * 127)", test_num);
        A = 8'h80; B = 8'h7F;
        #1;

        check_outputs(16'hC080);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity (-50 * 1)", test_num);
        A = -8'sd50; B = 8'sd1;
        #1;

        check_outputs(-16'sd50);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by -1 (25 * -1)", test_num);
        A = 8'sd25; B = -8'sd1;
        #1;

        check_outputs(-16'sd25);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        input [15:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
