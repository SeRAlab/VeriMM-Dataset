`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ABLK_CONFIG_0;
    reg [3:0] ABLK_CONFIG_1;
    reg ABLK_EN;
    reg ABLK_PG;
    reg ABLK_RESETn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABLK_CONFIG_0(ABLK_CONFIG_0),
        .ABLK_CONFIG_1(ABLK_CONFIG_1),
        .ABLK_EN(ABLK_EN),
        .ABLK_PG(ABLK_PG),
        .ABLK_RESETn(ABLK_RESETn)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Initialization and PG change", test_num);

        ABLK_RESETn = 0; ABLK_PG = 0; ABLK_EN = 0; ABLK_CONFIG_0 = 0; ABLK_CONFIG_1 = 0;
        #10;
        ABLK_RESETn = 1;
        #10;
        ABLK_PG = 1;
        #10;
        #1;

        check_outputs(1, 1, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Enable and Config 0", test_num);
        ABLK_RESETn = 0; #10; ABLK_RESETn = 1;
        #10;
        ABLK_EN = 1;
        #10;
        ABLK_CONFIG_0 = 4'hA;
        #10;
        #1;

        check_outputs(1, 1, 1, 4'hA, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Config 1 and Reset pulse", test_num);
        ABLK_RESETn = 0; #10; ABLK_RESETn = 1;
        #10;
        ABLK_CONFIG_1 = 4'h5;
        #10;
        ABLK_RESETn = 0;
        #10;
        ABLK_RESETn = 1;
        #10;
        #1;

        check_outputs(1, 1, 1, 4'hA, 4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Rapid configuration changes", test_num);
        ABLK_RESETn = 0; #10; ABLK_RESETn = 1;
        #10;
        ABLK_CONFIG_0 = 4'hF;
        #5;
        ABLK_CONFIG_1 = 4'hE;
        #5;
        ABLK_CONFIG_0 = 4'h0;
        #10;
        #1;

        check_outputs(1, 1, 1, 4'h0, 4'hE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Maximum Values", test_num);
        ABLK_RESETn = 0; #10; ABLK_RESETn = 1;
        #10;
        ABLK_PG = 1;
        ABLK_EN = 1;
        ABLK_CONFIG_0 = 4'hF;
        ABLK_CONFIG_1 = 4'hF;
        #10;
        #1;

        check_outputs(1, 1, 1, 4'hF, 4'hF);
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
