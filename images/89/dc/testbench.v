`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aux_reset_in;
    reg clk;
    reg dcm_locked;
    reg debug_sys_rst;
    reg ext_reset_in;
    reg reset;
    wire bus_struct_reset_out;
    wire interconnect_aresetn_out;
    wire mb_reset_out;
    wire peripheral_aresetn_out;
    wire peripheral_reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aux_reset_in(aux_reset_in),
        .clk(clk),
        .dcm_locked(dcm_locked),
        .debug_sys_rst(debug_sys_rst),
        .ext_reset_in(ext_reset_in),
        .reset(reset),
        .bus_struct_reset_out(bus_struct_reset_out),
        .interconnect_aresetn_out(interconnect_aresetn_out),
        .mb_reset_out(mb_reset_out),
        .peripheral_aresetn_out(peripheral_aresetn_out),
        .peripheral_reset_out(peripheral_reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ext_reset_in = 0;
            aux_reset_in = 0;
            debug_sys_rst = 0;
            dcm_locked = 0;
            repeat(5) @(posedge clk);
            #1;
            reset = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard Power-on Sequence", test_num);
            reset_dut();


            dcm_locked = 1;
            repeat(10) @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: External Reset Activation", test_num);
            reset_dut();

            dcm_locked = 1;
            ext_reset_in = 1;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Auxiliary Reset Activation", test_num);
            reset_dut();

            dcm_locked = 1;
            aux_reset_in = 1;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Debug System Reset Activation", test_num);
            reset_dut();

            dcm_locked = 1;
            debug_sys_rst = 1;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DCM Lock Loss", test_num);
            reset_dut();


            dcm_locked = 1;
            repeat(5) @(posedge clk);


            dcm_locked = 0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Reset Conditions", test_num);
            reset_dut();

            dcm_locked = 1;
            ext_reset_in = 1;
            aux_reset_in = 1;
            repeat(5) @(posedge clk);


            ext_reset_in = 0;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 1, 1, 1);
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
        input expected_bus_struct_reset_out;
        input expected_interconnect_aresetn_out;
        input expected_mb_reset_out;
        input expected_peripheral_aresetn_out;
        input expected_peripheral_reset_out;
        begin
            if (expected_bus_struct_reset_out === (expected_bus_struct_reset_out ^ bus_struct_reset_out ^ expected_bus_struct_reset_out) &&
                expected_interconnect_aresetn_out === (expected_interconnect_aresetn_out ^ interconnect_aresetn_out ^ expected_interconnect_aresetn_out) &&
                expected_mb_reset_out === (expected_mb_reset_out ^ mb_reset_out ^ expected_mb_reset_out) &&
                expected_peripheral_aresetn_out === (expected_peripheral_aresetn_out ^ peripheral_aresetn_out ^ expected_peripheral_aresetn_out) &&
                expected_peripheral_reset_out === (expected_peripheral_reset_out ^ peripheral_reset_out ^ expected_peripheral_reset_out)) begin
                $display("PASS");
                $display("  Outputs: bus_struct_reset_out=%b, interconnect_aresetn_out=%b, mb_reset_out=%b, peripheral_aresetn_out=%b, peripheral_reset_out=%b",
                         bus_struct_reset_out, interconnect_aresetn_out, mb_reset_out, peripheral_aresetn_out, peripheral_reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_struct_reset_out=%b, interconnect_aresetn_out=%b, mb_reset_out=%b, peripheral_aresetn_out=%b, peripheral_reset_out=%b",
                         expected_bus_struct_reset_out, expected_interconnect_aresetn_out, expected_mb_reset_out, expected_peripheral_aresetn_out, expected_peripheral_reset_out);
                $display("  Got:      bus_struct_reset_out=%b, interconnect_aresetn_out=%b, mb_reset_out=%b, peripheral_aresetn_out=%b, peripheral_reset_out=%b",
                         bus_struct_reset_out, interconnect_aresetn_out, mb_reset_out, peripheral_aresetn_out, peripheral_reset_out);
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
        $dumpvars(0,aux_reset_in, clk, dcm_locked, debug_sys_rst, ext_reset_in, reset, bus_struct_reset_out, interconnect_aresetn_out, mb_reset_out, peripheral_aresetn_out, peripheral_reset_out);
    end

endmodule
