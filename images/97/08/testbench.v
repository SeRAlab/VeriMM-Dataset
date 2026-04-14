`timescale 1ns/1ps

module mux_4to1_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] d2;
    reg [7:0] d3;
    reg [1:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_8bit dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Select d0");
            d0 = 8'hA5;
            d1 = 8'h5A;
            d2 = 8'hFF;
            d3 = 8'h00;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Select d1");
            d0 = 8'hA5;
            d1 = 8'h5A;
            d2 = 8'hFF;
            d3 = 8'h00;
            sel = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Select d2");
            d0 = 8'hA5;
            d1 = 8'h5A;
            d2 = 8'hFF;
            d3 = 8'h00;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Select d3");
            d0 = 8'hA5;
            d1 = 8'h5A;
            d2 = 8'hFF;
            d3 = 8'h00;
            sel = 2'b11;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: All inputs same");
            d0 = 8'h77;
            d1 = 8'h77;
            d2 = 8'h77;
            d3 = 8'h77;
            sel = 2'b10;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Boundary values (All 1s)");
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'hFF;
            sel = 2'b11;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Alternating bits pattern");
            d0 = 8'hAA;
            d1 = 8'h55;
            d2 = 8'h33;
            d3 = 8'hCC;
            sel = 2'b01;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Walking bit check");
            d0 = 8'h01;
            d1 = 8'h02;
            d2 = 8'h04;
            d3 = 8'h08;
            sel = 2'b10;
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_8bit Testbench");
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
        input [7:0] expected_y;
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
