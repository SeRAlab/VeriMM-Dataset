`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        A = 4'd0; B = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        A = 4'd5; B = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        A = 4'd2; B = 4'd3;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        A = 4'd7; B = 4'd7;
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase005;

    begin
        A = 4'd3; B = -4'd2;
        #1;

        check_outputs(8'hFA);
    end
        endtask

    task testcase006;

    begin
        A = -4'd4; B = 4'd2;
        #1;

        check_outputs(8'hF8);
    end
        endtask

    task testcase007;

    begin
        A = -4'd3; B = -4'd3;
        #1;

        check_outputs(8'h09);
    end
        endtask

    task testcase008;

    begin
        A = -4'd8; B = 4'd7;
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase009;

    begin
        A = -4'd8; B = -4'd8;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase010;

    begin
        A = 4'b1111; B = 4'b0001;
        #1;

        check_outputs(8'hFF);
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
