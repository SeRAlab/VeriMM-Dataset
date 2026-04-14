`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x0;
    reg [4:0] x1;
    reg [4:0] x2;
    reg [4:0] x3;
    reg [4:0] x4;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            x0 = 5'd0; x1 = 5'd0; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            x0 = 5'd1; x1 = 5'd1; x2 = 5'd1; x3 = 5'd1; x4 = 5'd1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum input values (Wrap around check)", test_num);
            x0 = 5'd31; x1 = 5'd31; x2 = 5'd31; x3 = 5'd31; x4 = 5'd31;

            #1;


            check_outputs(5'd27);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental sequence", test_num);
            x0 = 5'd1; x1 = 5'd2; x2 = 5'd3; x3 = 5'd4; x4 = 5'd5;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum equals exactly 32 (Wrap to 0)", test_num);
            x0 = 5'd10; x1 = 5'd10; x2 = 5'd10; x3 = 5'd1; x4 = 5'd1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random small values", test_num);
            x0 = 5'd7; x1 = 5'd3; x2 = 5'd2; x3 = 5'd8; x4 = 5'd4;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            x0 = 5'b10101;
            x1 = 5'b01010;
            x2 = 5'b10101;
            x3 = 5'b01010;
            x4 = 5'b00001;

            #1;


            check_outputs(5'd31);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single high input", test_num);
            x0 = 5'd20; x1 = 5'd0; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0;
            #1;

            check_outputs(5'd20);
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
        input [4:0] expected_y;
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
