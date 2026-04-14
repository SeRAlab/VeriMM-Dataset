`timescale 1ns/1ps

module pcie_interface_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] address;
    reg [2:0] command;
    wire [2:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_interface dut (
        .address(address),
        .command(command),
        .status(status)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Read Command (Input: 001)", test_num);
        address = 5'b00000;
        command = 3'b001;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write Command (Input: 010)", test_num);
        address = 5'b01010;
        command = 3'b010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Other Command (Input: 000)", test_num);
        address = 5'b11111;
        command = 3'b000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Undefined Command (Input: 111)", test_num);
        address = 5'b00110;
        command = 3'b111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Read Command with different address", test_num);
        address = 5'b10101;
        command = 3'b001;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write Command with different address", test_num);
        address = 5'b01100;
        command = 3'b010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Other Command (Input: 011)", test_num);
        address = 5'b00001;
        command = 3'b011;
        #1;

        check_outputs(3'b000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_interface Testbench");
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
        input [2:0] expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
