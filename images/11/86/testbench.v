`timescale 1ns/1ps

module bluetooth_status_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] status;
    wire [1:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_status_decoder dut (
        .status(status),
        .code(code)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Disconnected Status", test_num);
        status = 3'b000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing Connected Status", test_num);
        status = 3'b001;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing Pairing Status", test_num);
        status = 3'b010;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing Undefined Status (3'b011)", test_num);
        status = 3'b011;



        #1;
        $display("  Status applied: %b, Output received: %b", status, code);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_status_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
