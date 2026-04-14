`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg N;
    reg V;
    reg Z;
    reg [2:0] ctrl;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .N(N),
        .V(V),
        .Z(Z),
        .ctrl(ctrl),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        ctrl = 3'b111;
        N = 0; V = 0; Z = 0;
        $display("Test %0d: Ctrl=111, N=0, V=0, Z=0", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ctrl = 3'b111;
        N = 1; V = 0; Z = 0;
        $display("Test %0d: Ctrl=111, N=1, V=0, Z=0", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ctrl = 3'b111;
        N = 0; V = 1; Z = 0;
        $display("Test %0d: Ctrl=111, N=0, V=1, Z=0", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ctrl = 3'b111;
        N = 1; V = 1; Z = 0;
        $display("Test %0d: Ctrl=111, N=1, V=1, Z=0", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ctrl = 3'b111;
        N = 0; V = 0; Z = 1;
        $display("Test %0d: Ctrl=111, N=0, V=0, Z=1", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ctrl = 3'b011;
        N = 1; V = 0; Z = 0;
        $display("Test %0d: Ctrl=011, N=1, V=0, Z=0", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ctrl = 3'b000;
        N = 1; V = 1; Z = 1;
        $display("Test %0d: Ctrl=000, N=1, V=1, Z=1", test_num);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
