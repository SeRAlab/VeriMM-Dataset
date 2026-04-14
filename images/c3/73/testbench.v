`timescale 1ns/1ps

module SNPS_CLOCK_GATE_HIGH_d_ff_en_W64_0_3_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg EN;
    reg TE;
    wire ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SNPS_CLOCK_GATE_HIGH_d_ff_en_W64_0_3 dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .ENCLK(ENCLK)
    );
    task testcase001;

        begin
            $display("testcase001: System Reset/Initialization");
            CLK = 0;
            EN = 0;
            TE = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Normal Gating - EN=0, TE=0, CLK toggles");

            CLK = 0; EN = 0; TE = 0; #10;

            CLK = 1; #10;
            #1;

            check_outputs(1'b0);
            CLK = 0; #10;
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Normal Enable - EN=1, TE=0");

            CLK = 0; EN = 0; TE = 0; #10;
            EN = 1; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b1);
            CLK = 0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Test Enable Bypass - EN=0, TE=1");

            CLK = 0; EN = 0; TE = 0; #10;
            TE = 1; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b1);
            CLK = 0; #10;
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Glitch Protection - EN goes High when CLK is High");

            CLK = 0; EN = 0; TE = 0; #10;
            CLK = 1; #5;
            EN = 1; #5;


            #1;



            check_outputs(1'b0);
            CLK = 0; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b1);
            CLK = 0; #10;
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Glitch Protection - EN goes Low when CLK is High");

            CLK = 0; EN = 1; TE = 0; #10;
            CLK = 1; #5;
            EN = 0; #5;

            #1;


            check_outputs(1'b1);
            CLK = 0; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b0);
            CLK = 0; #10;
        end
        endtask

    task testcase007;

        begin
            $display("testcase007: Multiple Pulse Check");
            CLK = 0; EN = 1; TE = 0; #10;

            CLK = 1; #10; CLK = 0; #10;

            CLK = 1; #10; CLK = 0; #10;

            EN = 0; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b0);
            CLK = 0; #10;
        end
        endtask

    task testcase008;

        begin
            $display("testcase008: High-Z / Logic Stability Check");
            CLK = 0; EN = 1'bx; TE = 0; #10;
            CLK = 1; #10;

            if (ENCLK === 1'bx) $display("Note: Output is X when EN is X");
            CLK = 0; TE = 1; #10;
            CLK = 1; #10;
            #1;

            check_outputs(1'b1);
            CLK = 0; TE = 0; #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SNPS_CLOCK_GATE_HIGH_d_ff_en_W64_0_3 Testbench");
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
        input expected_ENCLK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b",
                         ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b",
                         expected_ENCLK);
                $display("  Got:      ENCLK=%b",
                         ENCLK);
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
