`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (combinational circuit)
    reg data;
    reg write_enable;
    wire stored_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .data(data),
        .write_enable(write_enable),
        .stored_data(stored_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Logic 1", test_num);

        data = 1'b1;
        write_enable = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Retain Logic 1 when write_enable is LOW", test_num);

        data = 1'b1;
        write_enable = 1'b1;
        #5;

        write_enable = 1'b0;
        data = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Logic 0", test_num);

        data = 1'b0;
        write_enable = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Retain Logic 0 when write_enable is LOW", test_num);

        data = 1'b0;
        write_enable = 1'b1;
        #5;

        write_enable = 1'b0;
        data = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data toggling with write_enable LOW", test_num);

        data = 1'b1;
        write_enable = 1'b1;
        #5;

        write_enable = 1'b0;
        #5;

        data = 1'b0; #5;
        data = 1'b1; #5;
        data = 1'b0; #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Write Operations", test_num);

        data = 1'b0; write_enable = 1'b1; #5;

        data = 1'b1; write_enable = 1'b1; #5;

        data = 1'b0; write_enable = 1'b1; #10;
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
        input expected_stored_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stored_data === (expected_stored_data ^ stored_data ^ expected_stored_data)) begin
                $display("PASS");
                $display("  Outputs: stored_data=%b",
                         stored_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_data=%b",
                         expected_stored_data);
                $display("  Got:      stored_data=%b",
                         stored_data);
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
