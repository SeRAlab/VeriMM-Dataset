`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg got_code_tick;
    reg [7:0] key_code;
    reg rst;
    wire [1:0] posicion;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .got_code_tick(got_code_tick),
        .key_code(key_code),
        .rst(rst),
        .posicion(posicion)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            got_code_tick = 0;
            key_code = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_key;

        input [N-1:0] code;
        begin
            @(posedge clk);
            #1;
            key_code = code;
            got_code_tick = 1;
            @(posedge clk);
            #1;
            got_code_tick = 0;
            key_code = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Increment (0->1)", test_num);
            reset_dut();
            send_key(8'h74);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Double Increment (0->1->2)", test_num);
            reset_dut();
            send_key(8'h74);
            send_key(8'h74);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment Wrap (2->0)", test_num);
            reset_dut();
            send_key(8'h74);
            send_key(8'h74);
            send_key(8'h74);
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Decrement Wrap (0->2)", test_num);
            reset_dut();
            send_key(8'h6B);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Decrements (0->2->1)", test_num);
            reset_dut();
            send_key(8'h6B);
            send_key(8'h6B);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Full Decrement Cycle (0->2->1->0)", test_num);
            reset_dut();
            send_key(8'h6B);
            send_key(8'h6B);
            send_key(8'h6B);
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Valid key without tick", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            key_code = 8'h74;
            got_code_tick = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Invalid key with tick", test_num);
            reset_dut();
            send_key(8'hFF);
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Mixed Incr/Decr (0->1->2->1)", test_num);
            reset_dut();
            send_key(8'h74);
            send_key(8'h74);
            send_key(8'h6B);
            #1;

            check_outputs(2'd1);
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
        input [1:0] expected_posicion;
        begin
            if (expected_posicion === (expected_posicion ^ posicion ^ expected_posicion)) begin
                $display("PASS");
                $display("  Outputs: posicion=%h",
                         posicion);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: posicion=%h",
                         expected_posicion);
                $display("  Got:      posicion=%h",
                         posicion);
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
        $dumpvars(0,clk, got_code_tick, key_code, rst, posicion);
    end

endmodule
