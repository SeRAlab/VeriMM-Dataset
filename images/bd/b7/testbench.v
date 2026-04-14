`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aumentar;
    reg clk;
    reg disminuir;
    reg reset;
    reg seleccion;
    wire au;
    wire dis;
    wire sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aumentar(aumentar),
        .clk(clk),
        .disminuir(disminuir),
        .reset(reset),
        .seleccion(seleccion),
        .au(au),
        .dis(dis),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Task: reset_dut");
            reset = 1;
            aumentar = 0;
            disminuir = 0;
            seleccion = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All signals stable high for 5 cycles", test_num);
            reset_dut();
            aumentar = 1;
            disminuir = 1;
            seleccion = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Glitch rejection (2 cycles high, then low)", test_num);
            reset_dut();
            aumentar = 1;
            disminuir = 1;
            seleccion = 1;
            repeat (2) @(posedge clk);
            aumentar = 0;
            disminuir = 0;
            seleccion = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Individual signal (only aumentar stable)", test_num);
            reset_dut();
            aumentar = 1;
            disminuir = 0;
            seleccion = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-stream", test_num);
            reset_dut();
            aumentar = 1;
            disminuir = 1;
            seleccion = 1;
            repeat (2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stable High to Stable Low transition", test_num);
            reset_dut();

            aumentar = 1; disminuir = 1; seleccion = 1;
            repeat (5) @(posedge clk);

            aumentar = 0; disminuir = 0; seleccion = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Breaking stability at the 4th cycle", test_num);
            reset_dut();
            aumentar = 1;
            repeat (3) @(posedge clk);
            aumentar = 0;
            @(posedge clk);
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_au;
        input expected_dis;
        input expected_sel;
        begin
            if (expected_au === (expected_au ^ au ^ expected_au) &&
                expected_dis === (expected_dis ^ dis ^ expected_dis) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: au=%b, dis=%b, sel=%b",
                         au, dis, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: au=%b, dis=%b, sel=%b",
                         expected_au, expected_dis, expected_sel);
                $display("  Got:      au=%b, dis=%b, sel=%b",
                         au, dis, sel);
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
        $dumpvars(0,aumentar, clk, disminuir, reset, seleccion, au, dis, sel);
    end

endmodule
