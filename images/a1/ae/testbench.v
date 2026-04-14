`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fifo_read;
    reg mesh_fifo_read;
    reg mesh_write_out;
    wire mesh_access_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fifo_read(fifo_read),
        .mesh_fifo_read(mesh_fifo_read),
        .mesh_write_out(mesh_write_out),
        .mesh_access_out(mesh_access_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Access Granted Condition (mesh_fifo_read=1, mesh_write_out=0)");
        mesh_fifo_read = 1'b1;
        mesh_write_out = 1'b0;
        fifo_read = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Access Denied (mesh_fifo_read=0, mesh_write_out=0)");
        mesh_fifo_read = 1'b0;
        mesh_write_out = 1'b0;
        fifo_read = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Access Denied (mesh_fifo_read=1, mesh_write_out=1)");
        mesh_fifo_read = 1'b1;
        mesh_write_out = 1'b1;
        fifo_read = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Access Denied (mesh_fifo_read=0, mesh_write_out=1)");
        mesh_fifo_read = 1'b0;
        mesh_write_out = 1'b1;
        fifo_read = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Access Granted with fifo_read high (mesh_fifo_read=1, mesh_write_out=0)");
        mesh_fifo_read = 1'b1;
        mesh_write_out = 1'b0;
        fifo_read = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Access Denied with all inputs high");
        mesh_fifo_read = 1'b1;
        mesh_write_out = 1'b1;
        fifo_read = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Access Denied with only fifo_read high");
        mesh_fifo_read = 1'b0;
        mesh_write_out = 1'b0;
        fifo_read = 1'b1;
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
        input expected_mesh_access_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mesh_access_out === (expected_mesh_access_out ^ mesh_access_out ^ expected_mesh_access_out)) begin
                $display("PASS");
                $display("  Outputs: mesh_access_out=%b",
                         mesh_access_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mesh_access_out=%b",
                         expected_mesh_access_out);
                $display("  Got:      mesh_access_out=%b",
                         mesh_access_out);
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
