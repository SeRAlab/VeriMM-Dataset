`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input0;
    reg [7:0] input1;
    reg sel;
    wire [7:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .input0(input0),
        .input1(input1),
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select input0 (typical values)", test_num);
            sel = 0;
            input0 = 8'hA5;
            input1 = 8'h5A;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select input1 (typical values)", test_num);
            sel = 1;
            input0 = 8'hA5;
            input1 = 8'h5A;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All zeros on input0", test_num);
            sel = 0;
            input0 = 8'h00;
            input1 = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones on input1", test_num);
            sel = 1;
            input0 = 8'h00;
            input1 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Walking bit pattern on input0", test_num);
            sel = 0;
            input0 = 8'h01;
            input1 = 8'h80;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Walking bit pattern on input1", test_num);
            sel = 1;
            input0 = 8'h01;
            input1 = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Alternating bit pattern (0xAA)", test_num);
            sel = 0;
            input0 = 8'hAA;
            input1 = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Alternating bit pattern (0x55)", test_num);
            sel = 1;
            input0 = 8'hAA;
            input1 = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input [7:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
