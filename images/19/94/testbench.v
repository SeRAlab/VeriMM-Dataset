`timescale 1ns/1ps

module bluetooth_status_checker_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] status;
    wire [31:0] message;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_status_checker dut (
        .status(status),
        .message(message)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing status 0 (DISC)", test_num);
        status = 3'd0;

        #1;


        check_outputs(32'h44495343);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing status 1 (CONN)", test_num);
        status = 3'd1;

        #1;


        check_outputs(32'h434F4E4E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing status 2 (CNCT)", test_num);
        status = 3'd2;

        #1;


        check_outputs(32'h434E4354);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing transition DISC -> CONN", test_num);
        status = 3'd0;
        #5;
        status = 3'd1;
        #1;

        check_outputs(32'h434F4E4E);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing transition CONN -> CNCT", test_num);
        status = 3'd1;
        #5;
        status = 3'd2;
        #1;

        check_outputs(32'h434E4354);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing transition CNCT -> DISC", test_num);
        status = 3'd2;
        #5;
        status = 3'd0;
        #1;

        check_outputs(32'h44495343);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_status_checker Testbench");
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
        input [31:0] expected_message;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_message === (expected_message ^ message ^ expected_message)) begin
                $display("PASS");
                $display("  Outputs: message=%h",
                         message);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: message=%h",
                         expected_message);
                $display("  Got:      message=%h",
                         message);
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
