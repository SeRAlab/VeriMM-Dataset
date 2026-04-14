`timescale 1ns/1ps

module mux_2_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2_to_1 dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select Input 0 (Normal Pattern)", test_num);
            in0 = 32'hAAAA_AAAA;
            in1 = 32'h5555_5555;
            sel = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select Input 1 (Normal Pattern)", test_num);
            in0 = 32'hAAAA_AAAA;
            in1 = 32'h5555_5555;
            sel = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select Input 0 (All Zeros vs All Ones)", test_num);
            in0 = 32'h0000_0000;
            in1 = 32'hFFFF_FFFF;
            sel = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select Input 1 (All Zeros vs All Ones)", test_num);
            in0 = 32'h0000_0000;
            in1 = 32'hFFFF_FFFF;
            sel = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 0 Hex Pattern DEADBEEF", test_num);
            in0 = 32'hDEAD_BEEF;
            in1 = 32'hCAFE_BABE;
            sel = 1'b0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 1 Hex Pattern CAFEBABE", test_num);
            in0 = 32'hDEAD_BEEF;
            in1 = 32'hCAFE_BABE;
            sel = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Edge Case - Both Inputs Same", test_num);
            in0 = 32'h1234_5678;
            in1 = 32'h1234_5678;
            sel = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Edge Case - Both Inputs Same (sel=1)", test_num);
            in0 = 32'h1234_5678;
            in1 = 32'h1234_5678;
            sel = 1'b1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Walking Bit on Input 0", test_num);
            in0 = 32'h8000_0000;
            in1 = 32'h0000_0001;
            sel = 1'b0;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Walking Bit on Input 1", test_num);
            in0 = 32'h8000_0000;
            in1 = 32'h0000_0001;
            sel = 1'b1;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2_to_1 Testbench");
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
        input [31:0] expected_out;
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
