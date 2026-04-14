`timescale 1ns/1ps

module eeprom_driver_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg write;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_driver dut (
        .data_in(data_in),
        .write(write),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Basic Write Functionality", test_num);

        write = 1; data_in = 5'h00; #5;

        write = 1; data_in = 5'h0A;
        #10;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Memory Retention (Hold Value)", test_num);

        write = 1; data_in = 5'h00; #5;

        write = 1; data_in = 5'h15;
        #10;

        write = 0; data_in = 5'h00;
        #10;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Retain All-Ones Pattern", test_num);

        write = 1; data_in = 5'h00; #5;

        write = 1; data_in = 5'h1F;
        #10;

        write = 0; data_in = 5'h00;
        #10;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Combinational Tracking (Write=1)", test_num);

        write = 1; data_in = 5'h00; #5;

        write = 1; data_in = 5'h07; #5;

        data_in = 5'h12;
        #10;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Overwrite Stored Value", test_num);

        write = 1; data_in = 5'h00; #5;

        write = 1; data_in = 5'h0A; #5;
        write = 0; #5;

        write = 1; data_in = 5'h1C; #10;
        #1;

        check_outputs(5'h1C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_driver Testbench");
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
