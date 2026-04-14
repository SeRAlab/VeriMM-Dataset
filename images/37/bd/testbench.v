`timescale 1ns/1ps

module firewall_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] packet_address;
    reg [3:0] protocol;
    wire permit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    firewall dut (
        .packet_address(packet_address),
        .protocol(protocol),
        .permit(permit)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Address 0x0000, Protocol TCP (0001)");
        packet_address = 16'h0000;
        protocol = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Address 0x7FFF, Protocol UDP (0010)");
        packet_address = 16'h7FFF;
        protocol = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Address 0x8000, Protocol TCP (0001)");
        packet_address = 16'h8000;
        protocol = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Address 0x1234, Protocol 0000");
        packet_address = 16'h1234;
        protocol = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Address 0x4000, Protocol 0011");
        packet_address = 16'h4000;
        protocol = 4'b0011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Address 0xFFFF, Protocol UDP (0010)");
        packet_address = 16'hFFFF;
        protocol = 4'b0010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Address 0xAAAA, Protocol 1111");
        packet_address = 16'hAAAA;
        protocol = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Address 0x3ABC, Protocol TCP (0001)");
        packet_address = 16'h3ABC;
        protocol = 4'b0001;
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
        $display("firewall Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_permit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_permit === (expected_permit ^ permit ^ expected_permit)) begin
                $display("PASS");
                $display("  Outputs: permit=%b",
                         permit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: permit=%b",
                         expected_permit);
                $display("  Got:      permit=%b",
                         permit);
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
