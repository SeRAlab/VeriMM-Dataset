`timescale 1ns/1ps

module clock_switch8_basic_tb;

    // Testbench signals (sequential circuit)
    reg clk0_i;
    reg clk1_i;
    reg clk2_i;
    reg clk3_i;
    reg clk4_i;
    reg clk5_i;
    reg clk6_i;
    reg clk7_i;
    reg enable;
    reg rst0_i;
    reg rst1_i;
    reg rst2_i;
    reg rst3_i;
    reg rst4_i;
    reg rst5_i;
    reg rst6_i;
    reg rst7_i;
    reg [2:0] select;
    wire clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_switch8_basic dut (
        .clk0_i(clk0_i),
        .clk1_i(clk1_i),
        .clk2_i(clk2_i),
        .clk3_i(clk3_i),
        .clk4_i(clk4_i),
        .clk5_i(clk5_i),
        .clk6_i(clk6_i),
        .clk7_i(clk7_i),
        .enable(enable),
        .rst0_i(rst0_i),
        .rst1_i(rst1_i),
        .rst2_i(rst2_i),
        .rst3_i(rst3_i),
        .rst4_i(rst4_i),
        .rst5_i(rst5_i),
        .rst6_i(rst6_i),
        .rst7_i(rst7_i),
        .select(select),
        .clk_o(clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk0_i = 0;
        forever #5 clk0_i = ~clk0_i;
    end

        task reset_dut;

        begin
            enable = 0;
            select = 3'b000;
            {rst0_i, rst1_i, rst2_i, rst3_i, rst4_i, rst5_i, rst6_i, rst7_i} = 8'hFF;
            #50;
            {rst0_i, rst1_i, rst2_i, rst3_i, rst4_i, rst5_i, rst6_i, rst7_i} = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Select clk0_i", test_num);
            reset_dut();
            enable = 1;
            select = 3'd0;
            #200;
            #1;

            check_outputs(clk0_i);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Select clk3_i", test_num);
            reset_dut();
            enable = 1;
            select = 3'd3;
            #200;
            #1;

            check_outputs(clk3_i);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Select clk7_i", test_num);
            reset_dut();
            enable = 1;
            select = 3'd7;
            #200;
            #1;

            check_outputs(clk7_i);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Enable signal low", test_num);
            reset_dut();
            enable = 0;
            select = 3'd2;
            #200;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Dynamic Switch clk0 to clk4", test_num);
            reset_dut();
            enable = 1;
            select = 3'd0;
            #100;
            select = 3'd4;
            #200;
            #1;

            check_outputs(clk4_i);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Reset during operation", test_num);
            reset_dut();
            enable = 1;
            select = 3'd5;
            #100;
            rst5_i = 1;
            #50;

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_switch8_basic Testbench");
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
        input expected_clk_o;
        begin
            if (expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o)) begin
                $display("PASS");
                $display("  Outputs: clk_o=%b",
                         clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_o=%b",
                         expected_clk_o);
                $display("  Got:      clk_o=%b",
                         clk_o);
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
        $dumpvars(0,clk0_i, clk1_i, clk2_i, clk3_i, clk4_i, clk5_i, clk6_i, clk7_i, enable, rst0_i, rst1_i, rst2_i, rst3_i, rst4_i, rst5_i, rst6_i, rst7_i, select, clk_o);
    end

endmodule
