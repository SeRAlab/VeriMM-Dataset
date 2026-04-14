`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg D;
    reg DPRA0;
    reg DPRA1;
    reg DPRA2;
    reg DPRA3;
    reg DPRA4;
    reg WCLK;
    reg WE;
    wire DPO;
    wire SPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .D(D),
        .DPRA0(DPRA0),
        .DPRA1(DPRA1),
        .DPRA2(DPRA2),
        .DPRA3(DPRA3),
        .DPRA4(DPRA4),
        .WCLK(WCLK),
        .WE(WE),
        .DPO(DPO),
        .SPO(SPO)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state - All inputs zero", test_num);
            A0=0; A1=0; A2=0; A3=0; A4=0;
            DPRA0=0; DPRA1=0; DPRA2=0; DPRA3=0; DPRA4=0;
            D=0; WE=0; WCLK=0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write '1' to address 0", test_num);

            A0=0; A1=0; A2=0; A3=0; A4=0;
            D=1; WE=1; WCLK=0;
            #5 WCLK=1; #5 WCLK=0;
            WE=0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write '1' to address 31 (All A=1)", test_num);

            A0=1; A1=1; A2=1; A3=1; A4=1;
            D=1; WE=1; WCLK=0;
            #5 WCLK=1; #5 WCLK=0;
            WE=0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read from address 31 using DPRA", test_num);

            DPRA0=1; DPRA1=1; DPRA2=1; DPRA3=1; DPRA4=1;

            A0=0; A1=0; A2=0; A3=0; A4=0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output remains low during active write", test_num);
            A0=0; A1=1; A2=0; A3=1; A4=0;
            D=1; WE=1; WCLK=0;
            #5 WCLK=1;

            #1;


            check_outputs(1'b0, 1'b0);
            #5 WCLK=0; WE=0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output remains low when WE is disabled", test_num);
            A0=1; A1=0; A2=1; A3=0; A4=1;
            D=1; WE=0; WCLK=0;
            #5 WCLK=1; #5 WCLK=0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output across different DPRA combinations", test_num);
            DPRA0=1; DPRA1=0; DPRA2=0; DPRA3=0; DPRA4=1;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
            DPRA0=0; DPRA1=1; DPRA2=1; DPRA3=1; DPRA4=0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Data Pulse", test_num);
            A0=0; A1=0; A2=1; A3=1; A4=0;
            D=0; WE=1; WCLK=0;
            #2 D=1; #2 D=0; #2 D=1;
            #2 WCLK=1; #5 WCLK=0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_DPO;
        input expected_SPO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DPO === (expected_DPO ^ DPO ^ expected_DPO) &&
                expected_SPO === (expected_SPO ^ SPO ^ expected_SPO)) begin
                $display("PASS");
                $display("  Outputs: DPO=%b, SPO=%b",
                         DPO, SPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO=%b, SPO=%b",
                         expected_DPO, expected_SPO);
                $display("  Got:      DPO=%b, SPO=%b",
                         DPO, SPO);
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
