`timescale 1ns/1ps

module bw_r_irf_72_2x1_mux_tb;

    // Testbench signals (combinational circuit)
    reg sel;
    reg [71:0] x0;
    reg [71:0] x1;
    wire [71:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_r_irf_72_2x1_mux dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x0 (x0=All Fs, x1=All 0s)", test_num);
        sel = 1'b0;
        x0 = 72'hFFFFFFFFFFFFFFFFFF;
        x1 = 72'h000000000000000000;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x1 (x0=All Fs, x1=All 0s)", test_num);
        sel = 1'b1;
        x0 = 72'hFFFFFFFFFFFFFFFFFF;
        x1 = 72'h000000000000000000;
        #1;

        check_outputs(72'h000000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x0 (Alternating Bit Patterns)", test_num);
        sel = 1'b0;
        x0 = 72'hAAAAAAAAAAAAAAAAAA;
        x1 = 72'h555555555555555555;
        #1;

        check_outputs(72'hAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x1 (Alternating Bit Patterns)", test_num);
        sel = 1'b1;
        x0 = 72'hAAAAAAAAAAAAAAAAAA;
        x1 = 72'h555555555555555555;
        #1;

        check_outputs(72'h555555555555555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x0 (Boundary bits)", test_num);
        sel = 1'b0;
        x0 = 72'h800000000000000001;
        x1 = 72'h000000000000000000;
        #1;

        check_outputs(72'h800000000000000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x1 (Boundary bits)", test_num);
        sel = 1'b1;
        x0 = 72'h000000000000000000;
        x1 = 72'h800000000000000001;
        #1;

        check_outputs(72'h800000000000000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select x0 (Random values)", test_num);
        sel = 1'b0;
        x0 = 72'h123456789ABCDEF012;
        x1 = 72'hFEDCBA9876543210FF;
        #1;

        check_outputs(72'h123456789ABCDEF012);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_r_irf_72_2x1_mux Testbench");
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
        input [71:0] expected_y;
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
