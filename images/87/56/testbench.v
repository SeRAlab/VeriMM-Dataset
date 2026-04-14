`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] lo;
    reg [35:0] u;
    reg [17:0] up;
    wire sat_mode;
    wire [35:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lo(lo),
        .u(u),
        .up(up),
        .sat_mode(sat_mode),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: u is within bounds", test_num);
            lo = 18'h01000;
            up = 18'h30000;
            u  = 36'h0000_15000;
            #1;

            check_outputs(1'b0, 36'h0000_15000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: u exceeds upper bound", test_num);
            lo = 18'h01000;
            up = 18'h20000;
            u  = 36'h0000_25000;
            #1;

            check_outputs(1'b1, 36'h0000_20000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: u falls below lower bound", test_num);
            lo = 18'h05000;
            up = 18'h3FFFF;
            u  = 36'h0000_02000;
            #1;

            check_outputs(1'b1, 36'h0000_05000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: u is exactly upper bound", test_num);
            lo = 18'h00000;
            up = 18'h2AAAA;
            u  = 36'h0000_2AAAA;
            #1;

            check_outputs(1'b0, 36'h0000_2AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: u is exactly lower bound", test_num);
            lo = 18'h11111;
            up = 18'h3FFFF;
            u  = 36'h0000_11111;
            #1;

            check_outputs(1'b0, 36'h0000_11111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Large 36-bit u input", test_num);
            lo = 18'h00000;
            up = 18'h3FFFF;
            u  = 36'hF_FFFF_FFFF;
            #1;

            check_outputs(1'b1, 36'h0000_3FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Zero input below lo bound", test_num);
            lo = 18'h00001;
            up = 18'h3FFFF;
            u  = 36'h0000_00000;
            #1;

            check_outputs(1'b1, 36'h0000_00001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Max bounds check", test_num);
            lo = 18'h00000;
            up = 18'h3FFFF;
            u  = 36'h0000_3FFFE;
            #1;

            check_outputs(1'b0, 36'h0000_3FFFE);
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
        input expected_sat_mode;
        input [35:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sat_mode === (expected_sat_mode ^ sat_mode ^ expected_sat_mode) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: sat_mode=%b, y=%h",
                         sat_mode, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sat_mode=%b, y=%h",
                         expected_sat_mode, expected_y);
                $display("  Got:      sat_mode=%b, y=%h",
                         sat_mode, y);
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
