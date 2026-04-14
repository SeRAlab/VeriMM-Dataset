`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] packet;
    reg [3:0] protocol;
    wire allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .enable(enable),
        .packet(packet),
        .protocol(protocol),
        .allowed(allowed)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Protocol 1, Enable 1 (Expected: Allowed)", test_num);
        enable = 1'b1;
        protocol = 4'd1;
        packet = 16'hA5A5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Protocol 2, Enable 1 (Expected: Allowed)", test_num);
        enable = 1'b1;
        protocol = 4'd2;
        packet = 16'h1234;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Protocol 3, Enable 1 (Expected: Allowed)", test_num);
        enable = 1'b1;
        protocol = 4'd3;
        packet = 16'hFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Protocol 0, Enable 1 (Expected: Blocked)", test_num);
        enable = 1'b1;
        protocol = 4'd0;
        packet = 16'h0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Protocol 4, Enable 1 (Expected: Blocked)", test_num);
        enable = 1'b1;
        protocol = 4'd4;
        packet = 16'hBEEF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Protocol 1, Enable 0 (Expected: Blocked)", test_num);
        enable = 1'b0;
        protocol = 4'd1;
        packet = 16'hA5A5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Protocol 2, Enable 0 (Expected: Blocked)", test_num);
        enable = 1'b0;
        protocol = 4'd2;
        packet = 16'h1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Protocol 15, Enable 1 (Expected: Blocked)", test_num);
        enable = 1'b1;
        protocol = 4'd15;
        packet = 16'hC0DE;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Protocol 0, Enable 0 (Expected: Blocked)", test_num);
        enable = 1'b0;
        protocol = 4'd0;
        packet = 16'h0000;
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
        $display("packet_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allowed === (expected_allowed ^ allowed ^ expected_allowed)) begin
                $display("PASS");
                $display("  Outputs: allowed=%b",
                         allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allowed=%b",
                         expected_allowed);
                $display("  Got:      allowed=%b",
                         allowed);
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
