`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] cmd_in;
    wire cmd_atomic_add;
    wire cmd_atomic_and;
    wire cmd_atomic_or;
    wire cmd_atomic_xor;
    wire cmd_cas;
    wire [3:0] cmd_length;
    wire [3:0] cmd_opcode;
    wire cmd_read;
    wire [2:0] cmd_size;
    wire [7:0] cmd_user;
    wire cmd_write;
    wire cmd_write_stop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cmd_in(cmd_in),
        .cmd_atomic_add(cmd_atomic_add),
        .cmd_atomic_and(cmd_atomic_and),
        .cmd_atomic_or(cmd_atomic_or),
        .cmd_atomic_xor(cmd_atomic_xor),
        .cmd_cas(cmd_cas),
        .cmd_length(cmd_length),
        .cmd_opcode(cmd_opcode),
        .cmd_read(cmd_read),
        .cmd_size(cmd_size),
        .cmd_user(cmd_user),
        .cmd_write(cmd_write),
        .cmd_write_stop(cmd_write_stop)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 0 - Read Command", test_num);
            cmd_in = 16'h0123;

            #1;


            check_outputs(0, 0, 0, 0, 0, 4'h1, 4'h0, 1, 3'h1, 8'h23, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 1 - Write Command", test_num);
            cmd_in = 16'h1A55;
            #1;

            check_outputs(0, 0, 0, 0, 0, 4'hA, 4'h1, 0, 3'h2, 8'h55, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 2 - Write Stop Command", test_num);
            cmd_in = 16'h2BC1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 4'hB, 4'h2, 0, 3'h6, 8'hC1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 3 - Atomic Add", test_num);
            cmd_in = 16'h3333;
            #1;

            check_outputs(1, 0, 0, 0, 0, 4'h3, 4'h3, 0, 3'h1, 8'h33, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 4 - Atomic And", test_num);
            cmd_in = 16'h4444;
            #1;

            check_outputs(0, 1, 0, 0, 0, 4'h4, 4'h4, 0, 3'h2, 8'h44, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 5 - Atomic Or", test_num);
            cmd_in = 16'h5555;
            #1;

            check_outputs(0, 0, 1, 0, 0, 4'h5, 4'h5, 0, 3'h2, 8'h55, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 6 - Atomic Xor", test_num);
            cmd_in = 16'h6666;
            #1;

            check_outputs(0, 0, 0, 1, 0, 4'h6, 4'h6, 0, 3'h3, 8'h66, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 7 - CAS", test_num);
            cmd_in = 16'h7777;
            #1;

            check_outputs(0, 0, 0, 0, 1, 4'h7, 4'h7, 0, 3'h3, 8'h77, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode F - Undefined/Maximum", test_num);
            cmd_in = 16'hF0FF;
            #1;

            check_outputs(0, 0, 0, 0, 0, 4'h0, 4'hF, 0, 3'h7, 8'hFF, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Opcode 8 - Boundary Zero User", test_num);
            cmd_in = 16'h8800;
            #1;

            check_outputs(0, 0, 0, 0, 0, 4'h8, 4'h8, 0, 3'h0, 8'h00, 0, 0);
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
        input expected_cmd_atomic_add;
        input expected_cmd_atomic_and;
        input expected_cmd_atomic_or;
        input expected_cmd_atomic_xor;
        input expected_cmd_cas;
        input [3:0] expected_cmd_length;
        input [3:0] expected_cmd_opcode;
        input expected_cmd_read;
        input [2:0] expected_cmd_size;
        input [7:0] expected_cmd_user;
        input expected_cmd_write;
        input expected_cmd_write_stop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cmd_atomic_add === (expected_cmd_atomic_add ^ cmd_atomic_add ^ expected_cmd_atomic_add) &&
                expected_cmd_atomic_and === (expected_cmd_atomic_and ^ cmd_atomic_and ^ expected_cmd_atomic_and) &&
                expected_cmd_atomic_or === (expected_cmd_atomic_or ^ cmd_atomic_or ^ expected_cmd_atomic_or) &&
                expected_cmd_atomic_xor === (expected_cmd_atomic_xor ^ cmd_atomic_xor ^ expected_cmd_atomic_xor) &&
                expected_cmd_cas === (expected_cmd_cas ^ cmd_cas ^ expected_cmd_cas) &&
                expected_cmd_length === (expected_cmd_length ^ cmd_length ^ expected_cmd_length) &&
                expected_cmd_opcode === (expected_cmd_opcode ^ cmd_opcode ^ expected_cmd_opcode) &&
                expected_cmd_read === (expected_cmd_read ^ cmd_read ^ expected_cmd_read) &&
                expected_cmd_size === (expected_cmd_size ^ cmd_size ^ expected_cmd_size) &&
                expected_cmd_user === (expected_cmd_user ^ cmd_user ^ expected_cmd_user) &&
                expected_cmd_write === (expected_cmd_write ^ cmd_write ^ expected_cmd_write) &&
                expected_cmd_write_stop === (expected_cmd_write_stop ^ cmd_write_stop ^ expected_cmd_write_stop)) begin
                $display("PASS");
                $display("  Outputs: cmd_atomic_add=%b, cmd_atomic_and=%b, cmd_atomic_or=%b, cmd_atomic_xor=%b, cmd_cas=%b, cmd_length=%h, cmd_opcode=%h, cmd_read=%b, cmd_size=%h, cmd_user=%h, cmd_write=%b, cmd_write_stop=%b",
                         cmd_atomic_add, cmd_atomic_and, cmd_atomic_or, cmd_atomic_xor, cmd_cas, cmd_length, cmd_opcode, cmd_read, cmd_size, cmd_user, cmd_write, cmd_write_stop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_atomic_add=%b, cmd_atomic_and=%b, cmd_atomic_or=%b, cmd_atomic_xor=%b, cmd_cas=%b, cmd_length=%h, cmd_opcode=%h, cmd_read=%b, cmd_size=%h, cmd_user=%h, cmd_write=%b, cmd_write_stop=%b",
                         expected_cmd_atomic_add, expected_cmd_atomic_and, expected_cmd_atomic_or, expected_cmd_atomic_xor, expected_cmd_cas, expected_cmd_length, expected_cmd_opcode, expected_cmd_read, expected_cmd_size, expected_cmd_user, expected_cmd_write, expected_cmd_write_stop);
                $display("  Got:      cmd_atomic_add=%b, cmd_atomic_and=%b, cmd_atomic_or=%b, cmd_atomic_xor=%b, cmd_cas=%b, cmd_length=%h, cmd_opcode=%h, cmd_read=%b, cmd_size=%h, cmd_user=%h, cmd_write=%b, cmd_write_stop=%b",
                         cmd_atomic_add, cmd_atomic_and, cmd_atomic_or, cmd_atomic_xor, cmd_cas, cmd_length, cmd_opcode, cmd_read, cmd_size, cmd_user, cmd_write, cmd_write_stop);
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
