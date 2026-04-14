`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] reg1_a_in;
    reg [15:0] reg2_a_in;
    reg [15:0] reg3_a_in;
    reg [1:0] selec;
    wire [15:0] a_bus_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg1_a_in(reg1_a_in),
        .reg2_a_in(reg2_a_in),
        .reg3_a_in(reg3_a_in),
        .selec(selec),
        .a_bus_out(a_bus_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select reg1_a_in (selec=01)", test_num);
            reg1_a_in = 16'hAAAA;
            reg2_a_in = 16'h5555;
            reg3_a_in = 16'h1234;
            selec = 2'b01;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select reg2_a_in (selec=10)", test_num);
            reg1_a_in = 16'hAAAA;
            reg2_a_in = 16'h5555;
            reg3_a_in = 16'h1234;
            selec = 2'b10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select reg3_a_in (selec=11)", test_num);
            reg1_a_in = 16'hAAAA;
            reg2_a_in = 16'h5555;
            reg3_a_in = 16'h1234;
            selec = 2'b11;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify logic for all zeros", test_num);
            reg1_a_in = 16'h0000;
            reg2_a_in = 16'hFFFF;
            reg3_a_in = 16'hFFFF;
            selec = 2'b01;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify logic for all ones", test_num);
            reg1_a_in = 16'h0000;
            reg2_a_in = 16'hFFFF;
            reg3_a_in = 16'h0000;
            selec = 2'b10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dynamic data change on reg3", test_num);
            reg1_a_in = 16'h1111;
            reg2_a_in = 16'h2222;
            reg3_a_in = 16'hBEEF;
            selec = 2'b11;
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_a_bus_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_bus_out === (expected_a_bus_out ^ a_bus_out ^ expected_a_bus_out)) begin
                $display("PASS");
                $display("  Outputs: a_bus_out=%h",
                         a_bus_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_bus_out=%h",
                         expected_a_bus_out);
                $display("  Got:      a_bus_out=%h",
                         a_bus_out);
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
