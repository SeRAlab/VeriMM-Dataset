`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg add_sub;
    reg [1:0] bwd;
    reg cin;
    reg [31:0] dataa;
    reg [31:0] datab;
    wire cout;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_sub(add_sub),
        .bwd(bwd),
        .cin(cin),
        .dataa(dataa),
        .datab(datab),
        .cout(cout),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Simple Addition", test_num);
        dataa = 32'h0000000A; datab = 32'h00000005; cin = 0; add_sub = 0; bwd = 2'b10;
        #1;

        check_outputs(1'b0, 1'b0, 32'h0000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Addition with Carry Out", test_num);
        dataa = 32'hFFFFFFFF; datab = 32'h00000001; cin = 0; add_sub = 0; bwd = 2'b10;
        #1;

        check_outputs(1'b1, 1'b0, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Addition with Signed Overflow", test_num);
        dataa = 32'h7FFFFFFF; datab = 32'h00000001; cin = 0; add_sub = 0; bwd = 2'b10;
        #1;

        check_outputs(1'b0, 1'b1, 32'h80000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Simple Subtraction (No Borrow)", test_num);
        dataa = 32'h00000014; datab = 32'h00000004; cin = 0; add_sub = 1; bwd = 2'b10;

        #1;


        check_outputs(1'b1, 1'b0, 32'h00000010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Subtraction with Borrow (Negative Result)", test_num);
        dataa = 32'h00000005; datab = 32'h0000000A; cin = 0; add_sub = 1; bwd = 2'b10;

        #1;


        check_outputs(1'b0, 1'b0, 32'hFFFFFBFB);


        #0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 32-bit Subtraction with Signed Overflow", test_num);
        dataa = 32'h80000000; datab = 32'h00000001; cin = 0; add_sub = 1; bwd = 2'b10;

        #1;


        check_outputs(1'b1, 1'b1, 32'h7FFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Carry-In", test_num);
        dataa = 32'h00000005; datab = 32'h00000005; cin = 1; add_sub = 0; bwd = 2'b10;
        #1;

        check_outputs(1'b0, 1'b0, 32'h0000000B);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction with Carry-In (acting as borrow)", test_num);
        dataa = 32'h0000000A; datab = 32'h00000004; cin = 1; add_sub = 1; bwd = 2'b10;

        #1;


        check_outputs(1'b1, 1'b0, 32'h00000005);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 8-bit Width Mode Addition (bwd=00)", test_num);
        dataa = 32'h0000007F; datab = 32'h00000001; cin = 0; add_sub = 0; bwd = 2'b00;

        #1;


        check_outputs(1'b0, 1'b1, 32'h00000080);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 16-bit Width Mode Addition (bwd=01)", test_num);
        dataa = 32'h0000FFFF; datab = 32'h00000001; cin = 0; add_sub = 0; bwd = 2'b01;

        #1;


        check_outputs(1'b1, 1'b0, 32'h00000000);
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
        testcase009();
        testcase010();
        
        
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
        input expected_cout;
        input expected_overflow;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, overflow=%b, result=%h",
                         cout, overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, overflow=%b, result=%h",
                         expected_cout, expected_overflow, expected_result);
                $display("  Got:      cout=%b, overflow=%b, result=%h",
                         cout, overflow, result);
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
