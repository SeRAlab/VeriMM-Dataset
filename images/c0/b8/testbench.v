`timescale 1ns/1ps

module thread_ring_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg rst_i;
    wire [2:0] thrd_0_o;
    wire [2:0] thrd_1_o;
    wire [2:0] thrd_2_o;
    wire [2:0] thrd_3_o;
    wire [2:0] thrd_4_o;
    wire [2:0] thrd_5_o;
    wire [2:0] thrd_6_o;
    wire [2:0] thrd_7_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thread_ring dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .thrd_0_o(thrd_0_o),
        .thrd_1_o(thrd_1_o),
        .thrd_2_o(thrd_2_o),
        .thrd_3_o(thrd_3_o),
        .thrd_4_o(thrd_4_o),
        .thrd_5_o(thrd_5_o),
        .thrd_6_o(thrd_6_o),
        .thrd_7_o(thrd_7_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            @(posedge clk_i);
            #2 rst_i = 0;
            @(negedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initializing and checking reset state", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking state after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk_i);
            @(negedge clk_i);

            #1;


            check_outputs(3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking state after 4 clock cycles (half rotation)", test_num);
            reset_dut();
            repeat(4) @(posedge clk_i);
            @(negedge clk_i);



            #1;




            check_outputs(3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checking state after 8 clock cycles (full rotation)", test_num);
            reset_dut();
            repeat(8) @(posedge clk_i);
            @(negedge clk_i);

            #1;


            check_outputs(3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Resetting mid-rotation", test_num);
            reset_dut();
            repeat(11) @(posedge clk_i);


            rst_i = 1;
            @(posedge clk_i);
            #2 rst_i = 0;
            @(negedge clk_i);


            #1;



            check_outputs(3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Tracking token '0' for 2 cycles", test_num);
            reset_dut();

            repeat(2) @(posedge clk_i);
            @(negedge clk_i);


            #1;



            check_outputs(3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thread_ring Testbench");
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
        input [2:0] expected_thrd_0_o;
        input [2:0] expected_thrd_1_o;
        input [2:0] expected_thrd_2_o;
        input [2:0] expected_thrd_3_o;
        input [2:0] expected_thrd_4_o;
        input [2:0] expected_thrd_5_o;
        input [2:0] expected_thrd_6_o;
        input [2:0] expected_thrd_7_o;
        begin
            if (expected_thrd_0_o === (expected_thrd_0_o ^ thrd_0_o ^ expected_thrd_0_o) &&
                expected_thrd_1_o === (expected_thrd_1_o ^ thrd_1_o ^ expected_thrd_1_o) &&
                expected_thrd_2_o === (expected_thrd_2_o ^ thrd_2_o ^ expected_thrd_2_o) &&
                expected_thrd_3_o === (expected_thrd_3_o ^ thrd_3_o ^ expected_thrd_3_o) &&
                expected_thrd_4_o === (expected_thrd_4_o ^ thrd_4_o ^ expected_thrd_4_o) &&
                expected_thrd_5_o === (expected_thrd_5_o ^ thrd_5_o ^ expected_thrd_5_o) &&
                expected_thrd_6_o === (expected_thrd_6_o ^ thrd_6_o ^ expected_thrd_6_o) &&
                expected_thrd_7_o === (expected_thrd_7_o ^ thrd_7_o ^ expected_thrd_7_o)) begin
                $display("PASS");
                $display("  Outputs: thrd_0_o=%h, thrd_1_o=%h, thrd_2_o=%h, thrd_3_o=%h, thrd_4_o=%h, thrd_5_o=%h, thrd_6_o=%h, thrd_7_o=%h",
                         thrd_0_o, thrd_1_o, thrd_2_o, thrd_3_o, thrd_4_o, thrd_5_o, thrd_6_o, thrd_7_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: thrd_0_o=%h, thrd_1_o=%h, thrd_2_o=%h, thrd_3_o=%h, thrd_4_o=%h, thrd_5_o=%h, thrd_6_o=%h, thrd_7_o=%h",
                         expected_thrd_0_o, expected_thrd_1_o, expected_thrd_2_o, expected_thrd_3_o, expected_thrd_4_o, expected_thrd_5_o, expected_thrd_6_o, expected_thrd_7_o);
                $display("  Got:      thrd_0_o=%h, thrd_1_o=%h, thrd_2_o=%h, thrd_3_o=%h, thrd_4_o=%h, thrd_5_o=%h, thrd_6_o=%h, thrd_7_o=%h",
                         thrd_0_o, thrd_1_o, thrd_2_o, thrd_3_o, thrd_4_o, thrd_5_o, thrd_6_o, thrd_7_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_i, rst_i, thrd_0_o, thrd_1_o, thrd_2_o, thrd_3_o, thrd_4_o, thrd_5_o, thrd_6_o, thrd_7_o);
    end

endmodule
