`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] port_in_0;
    reg [31:0] port_in_1;
    reg [31:0] port_in_2;
    reg [31:0] port_in_3;
    reg [1:0] sel_port;
    wire [31:0] port_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .port_in_0(port_in_0),
        .port_in_1(port_in_1),
        .port_in_2(port_in_2),
        .port_in_3(port_in_3),
        .sel_port(sel_port),
        .port_out(port_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select Port 0");
            test_num = 1;
            sel_port = 2'b00;
            port_in_0 = 32'hAAAAAAAA;
            port_in_1 = 32'h11111111;
            port_in_2 = 32'h22222222;
            port_in_3 = 32'h33333333;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select Port 1");
            test_num = 2;
            sel_port = 2'b01;
            port_in_0 = 32'hAAAAAAAA;
            port_in_1 = 32'h55555555;
            port_in_2 = 32'h22222222;
            port_in_3 = 32'h33333333;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select Port 2");
            test_num = 3;
            sel_port = 2'b10;
            port_in_0 = 32'hAAAAAAAA;
            port_in_1 = 32'h55555555;
            port_in_2 = 32'h12345678;
            port_in_3 = 32'h33333333;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select Port 3");
            test_num = 4;
            sel_port = 2'b11;
            port_in_0 = 32'hAAAAAAAA;
            port_in_1 = 32'h55555555;
            port_in_2 = 32'h12345678;
            port_in_3 = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All ones on Port 0");
            test_num = 5;
            sel_port = 2'b00;
            port_in_0 = 32'hFFFFFFFF;
            port_in_1 = 32'h00000000;
            port_in_2 = 32'h00000000;
            port_in_3 = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All zeros on Port 3");
            test_num = 6;
            sel_port = 2'b11;
            port_in_0 = 32'hFFFFFFFF;
            port_in_1 = 32'hFFFFFFFF;
            port_in_2 = 32'hFFFFFFFF;
            port_in_3 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternate Bit Pattern on Port 2");
            test_num = 7;
            sel_port = 2'b10;
            port_in_0 = 32'h0;
            port_in_1 = 32'h0;
            port_in_2 = 32'hF0F0F0F0;
            port_in_3 = 32'h0;
            #1;

            check_outputs(32'hF0F0F0F0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_port_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_port_out === (expected_port_out ^ port_out ^ expected_port_out)) begin
                $display("PASS");
                $display("  Outputs: port_out=%h",
                         port_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_out=%h",
                         expected_port_out);
                $display("  Got:      port_out=%h",
                         port_out);
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
