`timescale 1ns/1ps

module mux2to1_8bit_active_high_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_8bit_active_high dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            en = 1'b0;
            sel = 1'b0;
            in0 = 8'hAA;
            in1 = 8'h55;
            $display("Test Case 001: en=0, sel=0 (Disabled) - Expecting 0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            en = 1'b0;
            sel = 1'b1;
            in0 = 8'hAA;
            in1 = 8'h55;
            $display("Test Case 002: en=0, sel=1 (Disabled) - Expecting 0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            en = 1'b1;
            sel = 1'b0;
            in0 = 8'hA5;
            in1 = 8'h5A;
            $display("Test Case 003: en=1, sel=0 (Select in0) - Expecting A5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            en = 1'b1;
            sel = 1'b1;
            in0 = 8'hA5;
            in1 = 8'h5A;
            $display("Test Case 004: en=1, sel=1 (Select in1) - Expecting 5A");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            en = 1'b1;
            sel = 1'b0;
            in0 = 8'hFF;
            in1 = 8'h00;
            $display("Test Case 005: en=1, sel=0 (Select in0) - Expecting FF");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            en = 1'b1;
            sel = 1'b1;
            in0 = 8'hFF;
            in1 = 8'h00;
            $display("Test Case 006: en=1, sel=1 (Select in1) - Expecting 00");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            en = 1'b1;
            sel = 1'b0;
            in0 = 8'h12;
            in1 = 8'h34;
            $display("Test Case 007: en=1, sel=0 (Select in0) - Expecting 12");
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            en = 1'b1;
            sel = 1'b1;
            in0 = 8'h12;
            in1 = 8'h34;
            $display("Test Case 008: en=1, sel=1 (Select in1) - Expecting 34");
            #1;

            check_outputs(8'h34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_8bit_active_high Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
