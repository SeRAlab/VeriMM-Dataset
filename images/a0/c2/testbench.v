`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg [1:0] select;
    wire dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .select(select),
        .dataOut(dataOut)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A (00)", test_num);
        A = 32'hDEADBEEF;
        B = 32'h00000000;
        C = 32'hFFFFFFFF;
        select = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select B (01)", test_num);
        A = 32'h00000000;
        B = 32'hCAFEBABE;
        C = 32'h11111111;
        select = 2'b01;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select C (10)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        C = 32'h12345678;
        select = 2'b10;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones on A", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        C = 32'h00000000;
        select = 2'b00;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros on B", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        C = 32'hFFFFFFFF;
        select = 2'b01;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits on C", test_num);
        A = 32'h0;
        B = 32'h0;
        C = 32'h5A5A5A5A;
        select = 2'b10;
        #1;

        check_outputs(32'h5A5A5A5A);
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
        input expected_dataOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%b",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%b",
                         expected_dataOut);
                $display("  Got:      dataOut=%b",
                         dataOut);
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
