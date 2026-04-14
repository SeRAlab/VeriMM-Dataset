`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D0;
    reg [7:0] D1;
    reg [7:0] D2;
    reg [7:0] D3;
    reg [1:0] ctrl;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .ctrl(ctrl),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Selecting D0 (ctrl=00)", test_num);
        ctrl = 2'b00;
        D0 = 8'hA5;
        D1 = 8'h00;
        D2 = 8'h00;
        D3 = 8'h00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Selecting D1 (ctrl=01)", test_num);
        ctrl = 2'b01;
        D0 = 8'h11;
        D1 = 8'h22;
        D2 = 8'h33;
        D3 = 8'h44;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Selecting D2 (ctrl=10)", test_num);
        ctrl = 2'b10;
        D0 = 8'hFF;
        D1 = 8'hEE;
        D2 = 8'hDD;
        D3 = 8'hCC;
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selecting D3 (ctrl=11)", test_num);
        ctrl = 2'b11;
        D0 = 8'h01;
        D1 = 8'h02;
        D2 = 8'h04;
        D3 = 8'h08;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs identical (8'hFF)", test_num);
        D0 = 8'hFF; D1 = 8'hFF; D2 = 8'hFF; D3 = 8'hFF;
        ctrl = 2'b00; #1;
 check_outputs(8'hFF);
        ctrl = 2'b10; #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Invalid control (X)", test_num);
        D0 = 8'hAA; D1 = 8'hBB; D2 = 8'hCC; D3 = 8'hDD;
        ctrl = 2'bxx;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Selecting input containing 0x00", test_num);
        D0 = 8'h00; D1 = 8'hFF; D2 = 8'hFF; D3 = 8'hFF;
        ctrl = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Data changes while ctrl is fixed", test_num);
        ctrl = 2'b10;
        D2 = 8'h12; #1;
 check_outputs(8'h12);
        D2 = 8'h34; #1;
 check_outputs(8'h34);
        D2 = 8'h56; #1;
 check_outputs(8'h56);
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
