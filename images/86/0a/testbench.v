`timescale 1ns/1ps

module mux_2to1_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0;
    reg [7:0] d1;
    reg sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_8bit dut (
        .d0(d0),
        .d1(d1),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d0 with mixed pattern", test_num);
        d0 = 8'hA5;
        d1 = 8'h5A;
        sel = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d1 with mixed pattern", test_num);
        d0 = 8'hA5;
        d1 = 8'h5A;
        sel = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d0 with all zeros", test_num);
        d0 = 8'h00;
        d1 = 8'hFF;
        sel = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d1 with all ones", test_num);
        d0 = 8'h00;
        d1 = 8'hFF;
        sel = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle sel with same input values", test_num);
        d0 = 8'hCC;
        d1 = 8'hCC;
        sel = 1'b0;
        #5;
        sel = 1'b1;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d0 with walking one pattern", test_num);
        d0 = 8'h80;
        d1 = 8'h01;
        sel = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d1 with walking one pattern", test_num);
        d0 = 8'h80;
        d1 = 8'h01;
        sel = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_8bit Testbench");
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
        input [7:0] expected_y;
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
