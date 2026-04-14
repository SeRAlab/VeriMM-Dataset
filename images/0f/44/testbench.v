`timescale 1ns/1ps

module hash_table_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] addr;
    wire [2:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hash_table dut (
        .addr(addr),
        .data(data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Min Address Lookup", test_num);
            addr = 5'd0;

            #1;


            check_outputs(3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Range Address Lookup", test_num);
            addr = 5'd7;

            #1;


            check_outputs(3'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid Range Address Lookup", test_num);
            addr = 5'd16;

            #1;


            check_outputs(3'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Range Address Lookup", test_num);
            addr = 5'd25;

            #1;


            check_outputs(3'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Address Lookup", test_num);
            addr = 5'd31;

            #1;


            check_outputs(3'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hash_table Testbench");
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
        input [2:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
