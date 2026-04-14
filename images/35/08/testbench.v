`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .data0(data0),
        .data1(data1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select data0 (AAAA)", test_num);
        data0 = 16'hAAAA;
        data1 = 16'h5555;
        sel = 1'b0;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select data1 (5555)", test_num);
        data0 = 16'hAAAA;
        data1 = 16'h5555;
        sel = 1'b1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select data0 (FFFF)", test_num);
        data0 = 16'hFFFF;
        data1 = 16'h0000;
        sel = 1'b0;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select data1 (0000)", test_num);
        data0 = 16'hFFFF;
        data1 = 16'h0000;
        sel = 1'b1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic data0 update", test_num);
        sel = 1'b0;
        data1 = 16'hFACE;
        data0 = 16'h1234;
        #5;
        data0 = 16'h5678;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic data1 update", test_num);
        sel = 1'b1;
        data0 = 16'hDEAD;
        data1 = 16'hBEEF;
        #5;
        data1 = 16'hCAFE;
        #1;

        check_outputs(16'hCAFE);
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
