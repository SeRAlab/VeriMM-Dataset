`timescale 1ns/1ps

module mux2bit4to1_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] d0;
    reg [1:0] d1;
    reg [1:0] d2;
    reg [1:0] d3;
    reg [1:0] sel;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2bit4to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Selecting d0 (2'b01)");
            test_num = 1;
            d0 = 2'b01;
            d1 = 2'b10;
            d2 = 2'b11;
            d3 = 2'b00;
            sel = 2'b00;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Selecting d1 (2'b10)");
            test_num = 2;
            d0 = 2'b01;
            d1 = 2'b10;
            d2 = 2'b11;
            d3 = 2'b00;
            sel = 2'b01;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Selecting d2 (2'b11)");
            test_num = 3;
            d0 = 2'b01;
            d1 = 2'b10;
            d2 = 2'b11;
            d3 = 2'b00;
            sel = 2'b10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Selecting d3 (2'b00)");
            test_num = 4;
            d0 = 2'b01;
            d1 = 2'b10;
            d2 = 2'b11;
            d3 = 2'b00;
            sel = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All inputs identical (2'b11)");
            test_num = 5;
            d0 = 2'b11;
            d1 = 2'b11;
            d2 = 2'b11;
            d3 = 2'b11;
            sel = 2'b01;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High impedance check / Boundary values");
            test_num = 6;
            d0 = 2'b00;
            d1 = 2'b00;
            d2 = 2'b00;
            d3 = 2'b10;
            sel = 2'b11;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Selecting d0 with alternate bits");
            test_num = 7;
            d0 = 2'b10;
            d1 = 2'b01;
            d2 = 2'b01;
            d3 = 2'b01;
            sel = 2'b00;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2bit4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
