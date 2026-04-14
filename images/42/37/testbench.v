`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aumentar;
    reg chip_select;
    reg clk;
    reg disminuir;
    reg reset;
    wire out_aumentar;
    wire out_disminuir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aumentar(aumentar),
        .chip_select(chip_select),
        .clk(clk),
        .disminuir(disminuir),
        .reset(reset),
        .out_aumentar(out_aumentar),
        .out_disminuir(out_disminuir)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            aumentar = 0;
            disminuir = 0;
            chip_select = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increase Enabled", test_num);
            reset_dut();
            chip_select = 1;
            aumentar = 1;
            disminuir = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrease Enabled", test_num);
            reset_dut();
            chip_select = 1;
            aumentar = 0;
            disminuir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Chip Select Disabled", test_num);
            reset_dut();
            chip_select = 0;
            aumentar = 1;
            disminuir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both Control Signals Active", test_num);
            reset_dut();
            chip_select = 1;
            aumentar = 1;
            disminuir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            chip_select = 1;
            aumentar = 1;
            disminuir = 0;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
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
        input expected_out_aumentar;
        input expected_out_disminuir;
        begin
            if (expected_out_aumentar === (expected_out_aumentar ^ out_aumentar ^ expected_out_aumentar) &&
                expected_out_disminuir === (expected_out_disminuir ^ out_disminuir ^ expected_out_disminuir)) begin
                $display("PASS");
                $display("  Outputs: out_aumentar=%b, out_disminuir=%b",
                         out_aumentar, out_disminuir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_aumentar=%b, out_disminuir=%b",
                         expected_out_aumentar, expected_out_disminuir);
                $display("  Got:      out_aumentar=%b, out_disminuir=%b",
                         out_aumentar, out_disminuir);
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
        $dumpvars(0,aumentar, chip_select, clk, disminuir, reset, out_aumentar, out_disminuir);
    end

endmodule
