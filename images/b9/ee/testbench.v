`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] M;
    reg [15:0] Q;
    wire [15:0] Quo;
    wire [15:0] Rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .Q(Q),
        .Quo(Quo),
        .Rem(Rem)
    );
    task testcase001;

    begin
        test_num = 1;
        Q = 16'd100;
        M = 16'd10;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(16'd10, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Q = 16'd100;
        M = -16'd10;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(-16'd10, 16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Q = -16'd100;
        M = 16'd10;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(-16'd10, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Q = -16'd100;
        M = -16'd10;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(16'd10, 16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Q = 16'd17;
        M = 16'd5;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));

        #1;


        check_outputs(16'd3, 16'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Q = 16'd17;
        M = -16'd5;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));

        #1;


        check_outputs(-16'd3, 16'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Q = -16'd17;
        M = 16'd5;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));

        #1;


        check_outputs(-16'd3, -16'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Q = -16'd17;
        M = -16'd5;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));

        #1;


        check_outputs(16'd3, -16'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Q = 16'd0;
        M = 16'd1234;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        Q = 16'sh8000;
        M = 16'd2;
        $display("Testcase %0d: Min Negative / 2", test_num);
        #1;

        check_outputs(-16'd16384, 16'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        Q = -16'd555;
        M = -16'd555;
        $display("Testcase %0d: %d / %d", test_num, $signed(Q), $signed(M));
        #1;

        check_outputs(16'd1, 16'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_Quo;
        input [15:0] expected_Rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Quo === (expected_Quo ^ Quo ^ expected_Quo) &&
                expected_Rem === (expected_Rem ^ Rem ^ expected_Rem)) begin
                $display("PASS");
                $display("  Outputs: Quo=%h, Rem=%h",
                         Quo, Rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Quo=%h, Rem=%h",
                         expected_Quo, expected_Rem);
                $display("  Got:      Quo=%h, Rem=%h",
                         Quo, Rem);
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
