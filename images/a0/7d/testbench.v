`timescale 1ns/1ps

module mux2to1_8bit_active_low_tb;

    // Testbench signals (combinational circuit)
    reg en_n;
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_8bit_active_low dut (
        .en_n(en_n),
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: en_n = 1 (Disabled), sel = 0");
            test_num = 1;
            en_n = 1'b1;
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 1'b0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: en_n = 1 (Disabled), sel = 1");
            test_num = 2;
            en_n = 1'b1;
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 1'b1;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: en_n = 0 (Enabled), sel = 0");
            test_num = 3;
            en_n = 1'b0;
            in0 = 8'hDE;
            in1 = 8'hAD;
            sel = 1'b0;
            #10;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: en_n = 0 (Enabled), sel = 1");
            test_num = 4;
            en_n = 1'b0;
            in0 = 8'hDE;
            in1 = 8'hAD;
            sel = 1'b1;
            #10;
            #1;

            check_outputs(8'hAD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: en_n = 0 (Enabled), sel = 0, check logic level 1s");
            test_num = 5;
            en_n = 1'b0;
            in0 = 8'hFF;
            in1 = 8'h00;
            sel = 1'b0;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: en_n = 0 (Enabled), sel = 1, check logic level 1s");
            test_num = 6;
            en_n = 1'b0;
            in0 = 8'h00;
            in1 = 8'hFF;
            sel = 1'b1;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Switching enable while inputs are constant");
            test_num = 7;
            in0 = 8'h33;
            in1 = 8'hCC;
            sel = 1'b0;
            en_n = 1'b1;
            #5;
            en_n = 1'b0;
            #10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Switching select while enable is active");
            test_num = 8;
            en_n = 1'b0;
            in0 = 8'h12;
            in1 = 8'h34;
            sel = 1'b0;
            #5;
            sel = 1'b1;
            #10;
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
        $display("mux2to1_8bit_active_low Testbench");
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
