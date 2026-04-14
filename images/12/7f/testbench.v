`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (combinational circuit)
    reg data_in;
    reg read_en;
    reg write_en;
    wire stored_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .stored_value(stored_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write 1 and Read 1", test_num);

        data_in = 0;
        write_en = 0;
        read_en = 0;
        #10;


        data_in = 1;
        write_en = 1;
        #10;


        write_en = 0;
        read_en = 1;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write 0 and Read 0", test_num);

        data_in = 1;
        write_en = 0;
        read_en = 0;
        #10;


        data_in = 0;
        write_en = 1;
        #10;


        write_en = 0;
        read_en = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Data Persistence - Write 1, Change Data_in while Write disabled", test_num);

        data_in = 0;
        write_en = 0;
        read_en = 0;
        #10;


        data_in = 1;
        write_en = 1;
        #10;


        write_en = 0;
        data_in = 0;
        #10;


        read_en = 1;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verify Write Enable - Attempt write with write_en = 0", test_num);

        data_in = 0;
        write_en = 1;
        read_en = 0;
        #10;


        write_en = 0;
        data_in = 1;
        #10;


        read_en = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Sequential Overwrite - Write 1 then overwrite with 0", test_num);

        data_in = 0;
        write_en = 0;
        read_en = 0;
        #10;


        data_in = 1;
        write_en = 1;
        #10;


        data_in = 0;
        write_en = 1;
        #10;


        write_en = 0;
        read_en = 1;
        #10;

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
        $display("flash_memory_cell Testbench");
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
        input expected_stored_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stored_value === (expected_stored_value ^ stored_value ^ expected_stored_value)) begin
                $display("PASS");
                $display("  Outputs: stored_value=%b",
                         stored_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_value=%b",
                         expected_stored_value);
                $display("  Got:      stored_value=%b",
                         stored_value);
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
