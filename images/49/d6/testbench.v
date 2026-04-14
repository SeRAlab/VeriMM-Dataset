`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] addr;
    wire [47:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data(data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        addr = 16'h0000;
        #10;
        $display("Testcase %0d: Reading Addr 0", test_num);
        #1;

        check_outputs(48'h646562756721);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        addr = 16'h0001;
        #10;
        $display("Testcase %0d: Reading Addr 1", test_num);
        #1;

        check_outputs(48'h313233343536);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        addr = 16'h0002;
        #10;
        $display("Testcase %0d: Reading Addr 2", test_num);
        #1;

        check_outputs(48'h2d2d2d2d2d2d);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        addr = 16'h0004;
        #10;
        $display("Testcase %0d: Reading Addr 4", test_num);
        #1;

        check_outputs(48'h626520746f20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        addr = 16'h0007;
        #10;
        $display("Testcase %0d: Reading Addr 7", test_num);
        #1;

        check_outputs(48'h2d2d2d2d2d2d);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        addr = 16'h0008;
        #10;
        $display("Testcase %0d: Reading Addr 8 (Default)", test_num);
        #1;

        check_outputs(48'hffffffffffff);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        addr = 16'h000f;
        #10;
        $display("Testcase %0d: Reading Addr 15 (Default Boundary)", test_num);
        #1;

        check_outputs(48'hffffffffffff);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        addr = 16'h0010;
        #10;
        $display("Testcase %0d: Reading Addr 16 (Outside 4-bit range)", test_num);
        #1;

        check_outputs(48'hffffffffffff);
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
        input [47:0] expected_data;
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
