`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_clk;
    reg i_rst;
    reg i_start;
    reg [399:0] i_v_state;
    wire o_done;
    wire [399:0] o_v_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_start(i_start),
        .i_v_state(i_v_state),
        .o_done(o_done),
        .o_v_state(o_v_state)
    );
    task perform_reset;

        begin
            i_rst = 1;
            i_start = 0;
            i_v_state = 0;
            @(posedge i_clk);
            #1 i_rst = 0;
            @(posedge i_clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            perform_reset();

            i_v_state = 400'h0;
            i_start = 1;
            @(posedge i_clk);
            #2;


            #1;



            check_outputs(1'b0, {100{4'hF}});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            perform_reset();

            i_v_state = {100{4'hF}};
            i_start = 1;
            @(posedge i_clk);
            #2;


            #1;



            check_outputs(1'b0, 400'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern A (0xAAA...)", test_num);
            perform_reset();

            i_v_state = {100{4'hA}};
            i_start = 1;
            @(posedge i_clk);
            #2;


            #1;



            check_outputs(1'b0, {100{4'h5}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern B (0x555...)", test_num);
            perform_reset();

            i_v_state = {100{4'h5}};
            i_start = 1;
            @(posedge i_clk);
            #2;


            #1;



            check_outputs(1'b0, {100{4'hA}});
        end
        endtask

    task testcase005;

        reg [399:0] pattern;
        reg [399:0] inverted_pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Hex Pattern", test_num);
            perform_reset();

            pattern = {50{8'h12, 8'h34, 8'h56, 8'h78, 8'h9A}};
            inverted_pattern = ~pattern;

            i_v_state = pattern;
            i_start = 1;
            @(posedge i_clk);
            #2;

            #1;


            check_outputs(1'b0, inverted_pattern);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify o_done Constant Low", test_num);
            perform_reset();

            i_v_state = 400'hFEDCBA9876543210123456789ABCDEF000000000;
            i_start = 1;


            repeat(5) begin
                @(posedge i_clk);
                #2;
                if (o_done !== 1'b0) begin
                    $display("FAIL: o_done went HIGH unexpectedly");
                end
            end

            #1;


            check_outputs(1'b0, ~400'hFEDCBA9876543210123456789ABCDEF000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_o_done;
        input [399:0] expected_o_v_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_done === (expected_o_done ^ o_done ^ expected_o_done) &&
                expected_o_v_state === (expected_o_v_state ^ o_v_state ^ expected_o_v_state)) begin
                $display("PASS");
                $display("  Outputs: o_done=%b, o_v_state=%h",
                         o_done, o_v_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_done=%b, o_v_state=%h",
                         expected_o_done, expected_o_v_state);
                $display("  Got:      o_done=%b, o_v_state=%h",
                         o_done, o_v_state);
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
