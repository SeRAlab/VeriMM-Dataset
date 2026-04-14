`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] bus0;
    reg [15:0] bus1;
    reg [15:0] bus2;
    reg [15:0] bus3;
    reg enable;
    reg [1:0] s;
    wire [15:0] busout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus0(bus0),
        .bus1(bus1),
        .bus2(bus2),
        .bus3(bus3),
        .enable(enable),
        .s(s),
        .busout(busout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Bus 0 (Enable High)", test_num);
            bus0 = 16'hAAAA;
            bus1 = 16'h5555;
            bus2 = 16'h1234;
            bus3 = 16'hFACE;
            enable = 1'b1;
            s = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Bus 1 (Enable High)", test_num);
            bus0 = 16'hAAAA;
            bus1 = 16'h5555;
            bus2 = 16'h1234;
            bus3 = 16'hFACE;
            enable = 1'b1;
            s = 2'b01;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select Bus 2 (Enable High)", test_num);
            bus0 = 16'hAAAA;
            bus1 = 16'h5555;
            bus2 = 16'h1234;
            bus3 = 16'hFACE;
            enable = 1'b1;
            s = 2'b10;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Bus 3 (Enable High)", test_num);
            bus0 = 16'hAAAA;
            bus1 = 16'h5555;
            bus2 = 16'h1234;
            bus3 = 16'hFACE;
            enable = 1'b1;
            s = 2'b11;
            #1;

            check_outputs(16'hFACE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable Low (High Impedance State - Bus 0 Selected)", test_num);
            bus0 = 16'hAAAA;
            enable = 1'b0;
            s = 2'b00;
            #1;

            check_outputs(16'hzzzz);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable Low (High Impedance State - Bus 3 Selected)", test_num);
            bus3 = 16'hFACE;
            enable = 1'b0;
            s = 2'b11;
            #1;

            check_outputs(16'hzzzz);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All Zeros on Selected Bus 1", test_num);
            bus1 = 16'h0000;
            enable = 1'b1;
            s = 2'b01;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All Ones on Selected Bus 2", test_num);
            bus2 = 16'hFFFF;
            enable = 1'b1;
            s = 2'b10;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_busout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busout === (expected_busout ^ busout ^ expected_busout)) begin
                $display("PASS");
                $display("  Outputs: busout=%h",
                         busout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busout=%h",
                         expected_busout);
                $display("  Got:      busout=%h",
                         busout);
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
