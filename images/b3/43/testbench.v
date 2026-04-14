`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg contando;
    reg div_clk;
    reg rst;
    reg [3:0] time_value;
    wire terminado;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .contando(contando),
        .div_clk(div_clk),
        .rst(rst),
        .time_value(time_value),
        .terminado(terminado)
    );

    // Clock generation (10ns period)
    initial begin
        div_clk = 0;
        forever #5 div_clk = ~div_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            contando = 0;
            time_value = 4'b0000;
            @(posedge div_clk);
            #1 rst = 0;
            @(posedge div_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple count to 3", test_num);
            reset_dut();

            time_value = 4'd3;
            contando = 1;


            repeat (3) @(posedge div_clk);


            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Contando low (disable counting)", test_num);
            reset_dut();

            time_value = 4'd3;
            contando = 0;


            repeat (5) @(posedge div_clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            time_value = 4'd5;
            contando = 1;

            repeat (2) @(posedge div_clk);
            rst = 1;
            @(posedge div_clk);
            rst = 0;


            repeat (2) @(posedge div_clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count to maximum 4-bit value (15)", test_num);
            reset_dut();

            time_value = 4'd15;
            contando = 1;

            repeat (15) @(posedge div_clk);

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Terminado inhibited by contando=0 at target", test_num);
            reset_dut();

            time_value = 4'd4;
            contando = 1;

            repeat (3) @(posedge div_clk);

            contando = 0;
            @(posedge div_clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check if counter resets and clears terminado after success", test_num);
            reset_dut();

            time_value = 4'd2;
            contando = 1;

            repeat (2) @(posedge div_clk);
            @(posedge div_clk);

            #1;


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
        input expected_terminado;
        begin
            if (expected_terminado === (expected_terminado ^ terminado ^ expected_terminado)) begin
                $display("PASS");
                $display("  Outputs: terminado=%b",
                         terminado);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: terminado=%b",
                         expected_terminado);
                $display("  Got:      terminado=%b",
                         terminado);
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
        $dumpvars(0,contando, div_clk, rst, time_value, terminado);
    end

endmodule
