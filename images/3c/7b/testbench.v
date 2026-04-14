`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero", test_num);
            x0 = 8'd0;
            x1 = 8'd0;
            x2 = 8'd0;
            #10;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All inputs same (exact division)", test_num);
            x0 = 8'd4;
            x1 = 8'd4;
            x2 = 8'd4;
            #10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum values", test_num);
            x0 = 8'd255;
            x1 = 8'd255;
            x2 = 8'd255;
            #10;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Minimum non-zero (division with truncation)", test_num);
            x0 = 8'd1;
            x1 = 8'd1;
            x2 = 8'd1;
            #10;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Inputs resulting in remainder 0.5 (truncation check)", test_num);
            x0 = 8'd1;
            x1 = 8'd2;
            x2 = 8'd1;
            #10;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mixed values 1", test_num);
            x0 = 8'd10;
            x1 = 8'd20;
            x2 = 8'd30;
            #10;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed values 2 (truncation check)", test_num);
            x0 = 8'd100;
            x1 = 8'd50;
            x2 = 8'd10;
            #10;
            #1;

            check_outputs(8'd52);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Impulse response at x1", test_num);
            x0 = 8'd0;
            x1 = 8'd100;
            x2 = 8'd0;
            #10;
            #1;

            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
