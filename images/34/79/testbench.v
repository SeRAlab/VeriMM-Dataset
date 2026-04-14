`timescale 1ns/1ps

module QAM_Modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I;
    reg [3:0] Q;
    wire [1:0] symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    QAM_Modulator dut (
        .I(I),
        .Q(Q),
        .symbol(symbol)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            I = 4'd2; Q = 4'd2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            I = 4'b1110;
            Q = 4'd2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            I = 4'b1101;
            Q = 4'b1101;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            I = 4'd3;
            Q = 4'b1111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            I = 4'h7;
            Q = 4'h7;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            I = 4'h8;
            Q = 4'h8;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            I = 4'd1;
            Q = 4'd6;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            I = 4'd0;
            Q = 4'd0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("QAM_Modulator Testbench");
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
        input [1:0] expected_symbol;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_symbol === (expected_symbol ^ symbol ^ expected_symbol)) begin
                $display("PASS");
                $display("  Outputs: symbol=%h",
                         symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol=%h",
                         expected_symbol);
                $display("  Got:      symbol=%h",
                         symbol);
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
