`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [15:0] y;

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
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x0 = 8'd1; x1 = 8'd1; x2 = 8'd1;
            $display("Test %0d: All Ones (Unit Gain)", test_num);

            #1;


            check_outputs(16'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x0 = 8'd255; x1 = 8'd255; x2 = 8'd255;
            $display("Test %0d: Maximum Values (Saturation/Overflow Check)", test_num);

            #1;


            check_outputs(16'd1020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x0 = 8'd100; x1 = 8'd0; x2 = 8'd0;
            $display("Test %0d: Single Input x0", test_num);

            #1;


            check_outputs(16'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x0 = 8'd0; x1 = 8'd100; x2 = 8'd0;
            $display("Test %0d: Single Input x1 (Center Tap)", test_num);

            #1;


            check_outputs(16'd200);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd100;
            $display("Test %0d: Single Input x2", test_num);

            #1;


            check_outputs(16'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x0 = 8'd10; x1 = 8'd20; x2 = 8'd30;
            $display("Test %0d: Mixed Values", test_num);

            #1;


            check_outputs(16'd80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x0 = 8'd128; x1 = 8'd64; x2 = 8'd32;
            $display("Test %0d: Powers of Two", test_num);

            #1;


            check_outputs(16'd288);
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
        input [15:0] expected_y;
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
