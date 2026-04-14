`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    reg [1:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d0, d0=0", test_num);
            sel = 2'b00;
            d0 = 1'b0; d1 = 1'b1; d2 = 1'b1; d3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d0, d0=1", test_num);
            sel = 2'b00;
            d0 = 1'b1; d1 = 1'b0; d2 = 1'b0; d3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d1, d1=0", test_num);
            sel = 2'b01;
            d1 = 1'b0; d0 = 1'b1; d2 = 1'b1; d3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d1, d1=1", test_num);
            sel = 2'b01;
            d1 = 1'b1; d0 = 1'b0; d2 = 1'b0; d3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d2, d2=0", test_num);
            sel = 2'b10;
            d2 = 1'b0; d0 = 1'b1; d1 = 1'b1; d3 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d2, d2=1", test_num);
            sel = 2'b10;
            d2 = 1'b1; d0 = 1'b0; d1 = 1'b0; d3 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d3, d3=0", test_num);
            sel = 2'b11;
            d3 = 1'b0; d0 = 1'b1; d1 = 1'b1; d2 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d3, d3=1", test_num);
            sel = 2'b11;
            d3 = 1'b1; d0 = 1'b0; d1 = 1'b0; d2 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
