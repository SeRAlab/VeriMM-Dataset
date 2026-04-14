`timescale 1ns/1ps

module curr_source_sink_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [31:0] i_in;
    reg [31:0] i_set;
    wire [31:0] i_out;
    wire [31:0] i_sunk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    curr_source_sink dut (
        .enable(enable),
        .i_in(i_in),
        .i_set(i_set),
        .i_out(i_out),
        .i_sunk(i_sunk)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled Mode (i_in < i_set)", test_num);
            enable = 1'b0;
            i_set = 32'd100;
            i_in = 32'd40;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled Mode (i_in > i_set)", test_num);
            enable = 1'b0;
            i_set = 32'd50;
            i_in = 32'd150;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Current Sink Mode (i_in < i_set)", test_num);
            enable = 1'b1;
            i_set = 32'd100;
            i_in = 32'd30;

            #1;


            check_outputs(32'd0, 32'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Current Source Mode (i_in > i_set)", test_num);
            enable = 1'b1;
            i_set = 32'd50;
            i_in = 32'd120;

            #1;


            check_outputs(32'd70, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Balanced Mode (i_in == i_set)", test_num);
            enable = 1'b1;
            i_set = 32'd500;
            i_in = 32'd500;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sink Mode with i_in = 0", test_num);
            enable = 1'b1;
            i_set = 32'd1000;
            i_in = 32'd0;

            #1;


            check_outputs(32'd0, 32'd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Source Mode with i_set = 0", test_num);
            enable = 1'b1;
            i_set = 32'd0;
            i_in = 32'd250;

            #1;


            check_outputs(32'd250, 32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value Test", test_num);
            enable = 1'b1;
            i_set = 32'hFFFF0000;
            i_in = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h0000FFFF, 32'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("curr_source_sink Testbench");
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
        input [31:0] expected_i_out;
        input [31:0] expected_i_sunk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_out === (expected_i_out ^ i_out ^ expected_i_out) &&
                expected_i_sunk === (expected_i_sunk ^ i_sunk ^ expected_i_sunk)) begin
                $display("PASS");
                $display("  Outputs: i_out=%h, i_sunk=%h",
                         i_out, i_sunk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_out=%h, i_sunk=%h",
                         expected_i_out, expected_i_sunk);
                $display("  Got:      i_out=%h, i_sunk=%h",
                         i_out, i_sunk);
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
