`timescale 1ns/1ps

module decoder3to8_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder3to8 dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing input A=000 (0)", test_num);
        A2 = 0; A1 = 0; A0 = 0;
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing input A=001 (1)", test_num);
        A2 = 0; A1 = 0; A0 = 1;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing input A=010 (2)", test_num);
        A2 = 0; A1 = 1; A0 = 0;
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing input A=011 (3)", test_num);
        A2 = 0; A1 = 1; A0 = 1;
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing input A=100 (4)", test_num);
        A2 = 1; A1 = 0; A0 = 0;
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing input A=101 (5)", test_num);
        A2 = 1; A1 = 0; A0 = 1;
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing input A=110 (6)", test_num);
        A2 = 1; A1 = 1; A0 = 0;
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing input A=111 (7)", test_num);
        A2 = 1; A1 = 1; A0 = 1;
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder3to8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
