`timescale 1ns/1ps

module pcie_request_handler_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] address;
    reg [4:0] request;
    wire [4:0] response;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_request_handler dut (
        .address(address),
        .request(request),
        .response(response)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Address below 16 (Address = 0)", test_num);
        address = 5'd0;
        request = 5'b10101;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Address at upper boundary of valid range (Address = 15)", test_num);
        address = 5'd15;
        request = 5'b11111;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Address at lower boundary of invalid range (Address = 16)", test_num);
        address = 5'd16;
        request = 5'b10101;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Address at maximum value (Address = 31)", test_num);
        address = 5'd31;
        request = 5'b01010;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Middle valid address (Address = 8)", test_num);
        address = 5'd8;
        request = 5'b00111;
        #1;

        check_outputs(5'b00111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Request is 0 in valid range", test_num);
        address = 5'd5;
        request = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Address 20 with various request data", test_num);
        address = 5'd20;
        request = 5'b11001;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_request_handler Testbench");
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
        input [4:0] expected_response;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_response === (expected_response ^ response ^ expected_response)) begin
                $display("PASS");
                $display("  Outputs: response=%h",
                         response);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response=%h",
                         expected_response);
                $display("  Got:      response=%h",
                         response);
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
