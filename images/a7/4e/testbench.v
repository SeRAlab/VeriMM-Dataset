`timescale 1ns/1ps

module mux2to1_16bit_active_low_tb;

    // Testbench signals (combinational circuit)
    reg en_n;
    reg [15:0] in0;
    reg [15:0] in1;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_16bit_active_low dut (
        .en_n(en_n),
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled (en_n=0), Select 0", test_num);
            en_n = 1'b0;
            sel = 1'b0;
            in0 = 16'hA5A5;
            in1 = 16'h5A5A;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled (en_n=0), Select 1", test_num);
            en_n = 1'b0;
            sel = 1'b1;
            in0 = 16'hA5A5;
            in1 = 16'h5A5A;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disabled (en_n=1), Select 0", test_num);
            en_n = 1'b1;
            sel = 1'b0;
            in0 = 16'hFFFF;
            in1 = 16'h0000;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disabled (en_n=1), Select 1", test_num);
            en_n = 1'b1;
            sel = 1'b1;
            in0 = 16'h0000;
            in1 = 16'hFFFF;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled, Select 0, Boundary All 1s", test_num);
            en_n = 1'b0;
            sel = 1'b0;
            in0 = 16'hFFFF;
            in1 = 16'h1234;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled, Select 1, Boundary All 1s", test_num);
            en_n = 1'b0;
            sel = 1'b1;
            in0 = 16'h1234;
            in1 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled, Select 0, Alternating Bits", test_num);
            en_n = 1'b0;
            sel = 1'b0;
            in0 = 16'hCAFE;
            in1 = 16'hBABE;
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enabled, Select 1, Alternating Bits", test_num);
            en_n = 1'b0;
            sel = 1'b1;
            in0 = 16'hCAFE;
            in1 = 16'hBABE;
            #1;

            check_outputs(16'hBABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_16bit_active_low Testbench");
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
