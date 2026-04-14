`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Address;
    reg [7:0] switch0;
    reg [7:0] switch1;
    reg [7:0] switch2;
    reg [7:0] switch3;
    reg [7:0] switch4;
    reg [7:0] switch5;
    reg [7:0] switch6;
    reg [7:0] switch7;
    reg [7:0] userkey;
    wire [31:0] DataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .switch0(switch0),
        .switch1(switch1),
        .switch2(switch2),
        .switch3(switch3),
        .switch4(switch4),
        .switch5(switch5),
        .switch6(switch6),
        .switch7(switch7),
        .userkey(userkey),
        .DataOut(DataOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select S1 (Address 0)", test_num);
        Address = 8'h00;
        switch0 = 8'h11;
        switch1 = 8'h22;
        switch2 = 8'h33;
        switch3 = 8'h44;
        switch4 = 8'h00; switch5 = 8'h00; switch6 = 8'h00; switch7 = 8'h00;
        userkey = 8'h00;
        #1;

        check_outputs(32'h44332211);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select S2 (Address 1)", test_num);
        Address = 8'h01;
        switch0 = 8'h00; switch1 = 8'h00; switch2 = 8'h00; switch3 = 8'h00;
        switch4 = 8'h55;
        switch5 = 8'h66;
        switch6 = 8'h77;
        switch7 = 8'h88;
        userkey = 8'h00;
        #1;

        check_outputs(32'h88776655);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select S3 (Address 2)", test_num);
        Address = 8'h02;
        switch0 = 8'hAA; switch1 = 8'hAA; switch2 = 8'hAA; switch3 = 8'hAA;
        userkey = 8'h0F;
        #1;

        check_outputs(32'h000000F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select S1 - All FF", test_num);
        Address = 8'h00;
        switch0 = 8'hFF; switch1 = 8'hFF; switch2 = 8'hFF; switch3 = 8'hFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select S2 - Alternating Pattern", test_num);
        Address = 8'h01;
        switch4 = 8'hAA; switch5 = 8'h55; switch6 = 8'hAA; switch7 = 8'h55;
        #1;

        check_outputs(32'h55AA55AA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select S3 - User Key FF", test_num);
        Address = 8'h02;
        userkey = 8'hFF;
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
        input [31:0] expected_DataOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h",
                         DataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h",
                         expected_DataOut);
                $display("  Got:      DataOut=%h",
                         DataOut);
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
