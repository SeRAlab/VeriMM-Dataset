`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_signal;
    wire [2:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input = 0 (Region 1)", test_num);
        in_signal = 5'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input = 3 (Region 1 Boundary)", test_num);
        in_signal = 5'd3;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input = 4 (Region 2: 4-3=1)", test_num);
        in_signal = 5'd4;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input = 6 (Region 2: 6-3=3)", test_num);
        in_signal = 5'd6;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input = 9 (Region 2: 9-3=6)", test_num);
        in_signal = 5'd9;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input = 10 (Region 2: 10-3=7)", test_num);
        in_signal = 5'd10;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input = 11 (Region 2: Clamp 8 to 7)", test_num);
        in_signal = 5'd11;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input = 12 (Region 2: Clamp 9 to 7)", test_num);
        in_signal = 5'd12;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input = 13 (Region 3 Boundary: Fixed 7)", test_num);
        in_signal = 5'd13;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input = 31 (Region 3 Max: Fixed 7)", test_num);
        in_signal = 5'd31;
        #1;

        check_outputs(3'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
