`timescale 1ns/1ps

module mux2to1_16bit_active_high_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [15:0] in0;
    reg [15:0] in1;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_16bit_active_high dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable High, Sel 0", test_num);
            en = 1'b1;
            sel = 1'b0;
            in0 = 16'hAAAA;
            in1 = 16'h5555;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable High, Sel 1", test_num);
            en = 1'b1;
            sel = 1'b1;
            in0 = 16'hAAAA;
            in1 = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable Low, Sel 0", test_num);
            en = 1'b0;
            sel = 1'b0;
            in0 = 16'hFFFF;
            in1 = 16'h1234;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Low, Sel 1", test_num);
            en = 1'b0;
            sel = 1'b1;
            in0 = 16'h1234;
            in1 = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable High, Sel 0 (All 1s)", test_num);
            en = 1'b1;
            sel = 1'b0;
            in0 = 16'hFFFF;
            in1 = 16'h0000;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable High, Sel 1 (All 0s)", test_num);
            en = 1'b1;
            sel = 1'b1;
            in0 = 16'hFFFF;
            in1 = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Data switching check", test_num);
            en = 1'b1;
            in0 = 16'h1234;
            in1 = 16'h5678;
            sel = 1'b0;
            #5;
            sel = 1'b1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Enable de-assertion check", test_num);
            in0 = 16'hBEEF;
            in1 = 16'hCAFE;
            sel = 1'b0;
            en = 1'b1;
            #5;
            en = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_16bit_active_high Testbench");
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
        input [15:0] expected_out;
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
