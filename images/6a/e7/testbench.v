`timescale 1ns/1ps

module mux2to1_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg sel;
    wire [63:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_64bit dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select input A (all zeros)", test_num);
        a = 64'h0000_0000_0000_0000;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        sel = 1'b0;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select input B (all ones)", test_num);
        a = 64'h0000_0000_0000_0000;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        sel = 1'b1;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select input A (alternating bits)", test_num);
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'h5555_5555_5555_5555;
        sel = 1'b0;
        #1;

        check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select input B (alternating bits)", test_num);
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'h5555_5555_5555_5555;
        sel = 1'b1;
        #1;

        check_outputs(64'h5555_5555_5555_5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select input A (mixed hex pattern)", test_num);
        a = 64'h1234_5678_9ABC_DEF0;
        b = 64'hFEDC_BA98_7654_3210;
        sel = 1'b0;
        #1;

        check_outputs(64'h1234_5678_9ABC_DEF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select input B (mixed hex pattern)", test_num);
        a = 64'h1234_5678_9ABC_DEF0;
        b = 64'hFEDC_BA98_7654_3210;
        sel = 1'b1;
        #1;

        check_outputs(64'hFEDC_BA98_7654_3210);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Large value transition A", test_num);
        a = 64'hDEAD_BEEF_CAFE_BABE;
        b = 64'h0000_0000_0000_0000;
        sel = 1'b0;
        #1;

        check_outputs(64'hDEAD_BEEF_CAFE_BABE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large value transition B", test_num);
        a = 64'h0000_0000_0000_0000;
        b = 64'h8000_0000_0000_0001;
        sel = 1'b1;
        #1;

        check_outputs(64'h8000_0000_0000_0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_64bit Testbench");
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
        input [63:0] expected_y;
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
