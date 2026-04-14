`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg write_data;
    wire read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .control(control),
        .write_data(write_data),
        .read_data(read_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Write 0 and Read back", test_num);

        control = 0;
        write_data = 0;
        #10;

        control = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write 1 and Read back", test_num);

        control = 0;
        write_data = 1;
        #10;

        control = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Verify write inhibition (Read mode prevents storage change)", test_num);

        control = 0;
        write_data = 0;
        #10;

        control = 1;
        #5;

        write_data = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overwrite previous value (1 -> 0)", test_num);

        control = 0;
        write_data = 1;
        #10;

        control = 0;
        write_data = 0;
        #10;

        control = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Stability of output during data input change", test_num);

        control = 0;
        write_data = 1;
        #10;

        control = 1;
        #5;

        write_data = 0;
        #5;
        write_data = 1;
        #5;
        write_data = 0;
        #5;

        #1;


        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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
        input expected_read_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%b",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%b",
                         expected_read_data);
                $display("  Got:      read_data=%b",
                         read_data);
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
