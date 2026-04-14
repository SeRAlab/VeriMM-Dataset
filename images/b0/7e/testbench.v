`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg CLRbar;
    reg [31:0] D;
    reg PREbar;
    wire [31:0] Q;
    wire [31:0] Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CLRbar(CLRbar),
        .D(D),
        .PREbar(PREbar),
        .Q(Q),
        .Qbar(Qbar)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asynchronous Clear (Active Low)", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'hAAAAAAAA; #10;

        #1;


        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Asynchronous Preset (Active Low)", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; PREbar = 0; #10;

        #1;


        check_outputs(32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Synchronous Load (Pattern 0x12345678)", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; PREbar = 1; D = 32'h12345678; #5;

        C = 1; #10;

        #1;


        check_outputs(32'h12345678, 32'hEDCBA987);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Synchronous Load (Pattern 0xEDCBA987)", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; PREbar = 1; D = 32'hEDCBA987; #5;

        C = 1; #10;

        #1;


        check_outputs(32'hEDCBA987, 32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: No change on falling edge", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; D = 32'h5555AAAA; #5;
        C = 1; #10;

        D = 32'hFFFFFFFF;
        C = 0; #10;

        #1;


        check_outputs(32'h5555AAAA, 32'hAAAA5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Asynchronous Clear overriding Clock", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 0; D = 32'hFFFFFFFF; #5;
        C = 1; #10;

        #1;


        check_outputs(32'h00000000, 32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Asynchronous Preset overriding Clock", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; PREbar = 0; #5;

        D = 32'h00000000;
        C = 1; #10;

        #1;


        check_outputs(32'hFFFFFFFF, 32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Data stability without clock edges", test_num);

        CLRbar = 0; PREbar = 1; C = 0; D = 32'h0; #10;

        CLRbar = 1; D = 32'hA5A5A5A5; #5;
        C = 1; #10;
        C = 0; #5;

        D = 32'h00000000; #10;

        #1;


        check_outputs(32'hA5A5A5A5, 32'h5A5A5A5A);
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
        input [31:0] expected_Q;
        input [31:0] expected_Qbar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Qbar=%h",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Qbar=%h",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%h, Qbar=%h",
                         Q, Qbar);
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
