`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d1_enabled_write_endofpacket;
    reg fifo_datavalid;
    reg write_waitrequest;
    wire fifo_read;
    wire inc_write;
    wire mem_write_n;
    wire write_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d1_enabled_write_endofpacket(d1_enabled_write_endofpacket),
        .fifo_datavalid(fifo_datavalid),
        .write_waitrequest(write_waitrequest),
        .fifo_read(fifo_read),
        .inc_write(inc_write),
        .mem_write_n(mem_write_n),
        .write_select(write_select)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Idle State (No Data Valid)", test_num);
        d1_enabled_write_endofpacket = 0;
        fifo_datavalid = 0;
        write_waitrequest = 0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Active Write (Data Valid, No Wait)", test_num);
        d1_enabled_write_endofpacket = 0;
        fifo_datavalid = 1;
        write_waitrequest = 0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Write Wait (Data Valid, Wait Active)", test_num);
        d1_enabled_write_endofpacket = 0;
        fifo_datavalid = 1;
        write_waitrequest = 1;



        #1;




        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: End of Packet (Data Valid, EOP Active)", test_num);
        d1_enabled_write_endofpacket = 1;
        fifo_datavalid = 1;
        write_waitrequest = 0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: EOP and Wait active simultaneously", test_num);
        d1_enabled_write_endofpacket = 1;
        fifo_datavalid = 1;
        write_waitrequest = 1;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Idle but Wait Request present", test_num);
        d1_enabled_write_endofpacket = 0;
        fifo_datavalid = 0;
        write_waitrequest = 1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_fifo_read;
        input expected_inc_write;
        input expected_mem_write_n;
        input expected_write_select;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fifo_read === (expected_fifo_read ^ fifo_read ^ expected_fifo_read) &&
                expected_inc_write === (expected_inc_write ^ inc_write ^ expected_inc_write) &&
                expected_mem_write_n === (expected_mem_write_n ^ mem_write_n ^ expected_mem_write_n) &&
                expected_write_select === (expected_write_select ^ write_select ^ expected_write_select)) begin
                $display("PASS");
                $display("  Outputs: fifo_read=%b, inc_write=%b, mem_write_n=%b, write_select=%b",
                         fifo_read, inc_write, mem_write_n, write_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_read=%b, inc_write=%b, mem_write_n=%b, write_select=%b",
                         expected_fifo_read, expected_inc_write, expected_mem_write_n, expected_write_select);
                $display("  Got:      fifo_read=%b, inc_write=%b, mem_write_n=%b, write_select=%b",
                         fifo_read, inc_write, mem_write_n, write_select);
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
