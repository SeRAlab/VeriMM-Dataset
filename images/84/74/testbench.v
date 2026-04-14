`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D0;
    reg [7:0] D1;
    reg [7:0] D2;
    reg [7:0] D3;
    reg [1:0] SEL;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Selecting D0 (SEL=00)");
            D0 = 8'hA5;
            D1 = 8'h5A;
            D2 = 8'hFF;
            D3 = 8'h00;
            SEL = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Selecting D1 (SEL=01)");
            D0 = 8'h11;
            D1 = 8'h22;
            D2 = 8'h33;
            D3 = 8'h44;
            SEL = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Selecting D2 (SEL=10)");
            D0 = 8'hDE;
            D1 = 8'hAD;
            D2 = 8'hBE;
            D3 = 8'hEF;
            SEL = 2'b10;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Selecting D3 (SEL=11)");
            D0 = 8'h01;
            D1 = 8'h02;
            D2 = 8'h04;
            D3 = 8'h08;
            SEL = 2'b11;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All inputs 0xFF, SEL=01");
            D0 = 8'hFF;
            D1 = 8'hFF;
            D2 = 8'hFF;
            D3 = 8'hFF;
            SEL = 2'b01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All inputs 0x00, SEL=11");
            D0 = 8'h00;
            D1 = 8'h00;
            D2 = 8'h00;
            D3 = 8'h00;
            SEL = 2'b11;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Dynamic change on selected line (D2)");
            D0 = 8'h12;
            D1 = 8'h34;
            D2 = 8'h56;
            D3 = 8'h78;
            SEL = 2'b10;
            #5;
            D2 = 8'h9A;
            #1;

            check_outputs(8'h9A);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Change on non-selected line (D1) when SEL=00");
            D0 = 8'hCC;
            D1 = 8'h11;
            D2 = 8'h22;
            D3 = 8'h33;
            SEL = 2'b00;
            #5;
            D1 = 8'hEE;
            #1;

            check_outputs(8'hCC);
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
