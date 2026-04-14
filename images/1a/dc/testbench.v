`timescale 1ns/1ps

module mux4to1_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [1:0] select;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1_16bit dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Selecting data0", test_num);
        data0 = 16'hAAAA;
        data1 = 16'h5555;
        data2 = 16'h1234;
        data3 = 16'hFFFF;
        select = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Selecting data1", test_num);
        data0 = 16'h0000;
        data1 = 16'h5678;
        data2 = 16'hABCD;
        data3 = 16'hEF01;
        select = 2'b01;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Selecting data2", test_num);
        data0 = 16'hF0F0;
        data1 = 16'h0F0F;
        data2 = 16'hBEEF;
        data3 = 16'hC0DE;
        select = 2'b10;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selecting data3", test_num);
        data0 = 16'h1111;
        data1 = 16'h2222;
        data2 = 16'h3333;
        data3 = 16'h4444;
        select = 2'b11;
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs identical (All Zeros)", test_num);
        data0 = 16'h0000;
        data1 = 16'h0000;
        data2 = 16'h0000;
        data3 = 16'h0000;
        select = 2'b01;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All inputs identical (All Ones)", test_num);
        data0 = 16'hFFFF;
        data1 = 16'hFFFF;
        data2 = 16'hFFFF;
        data3 = 16'hFFFF;
        select = 2'b11;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        data0 = 16'h5555;
        data1 = 16'hAAAA;
        data2 = 16'h3333;
        data3 = 16'hCCCC;
        select = 2'b10;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1_16bit Testbench");
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
