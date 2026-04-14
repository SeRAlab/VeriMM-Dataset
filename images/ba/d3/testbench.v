`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] addr;
    reg [63:0] data_in;
    reg [1:0] datamode;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data_in(data_in),
        .datamode(datamode),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        addr = 3'b000;
        datamode = 2'b00;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_00000010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        addr = 3'b011;
        datamode = 2'b00;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_00000076);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        addr = 3'b111;
        datamode = 2'b00;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_000000FE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        addr = 3'b000;
        datamode = 2'b01;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_00003210);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        addr = 3'b100;
        datamode = 2'b01;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_0000BA98);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        addr = 3'b000;
        datamode = 2'b10;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_76543210);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        addr = 3'b100;
        datamode = 2'b10;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_FEDCBA98);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        addr = 3'b010;
        datamode = 2'b10;
        data_in = 64'hFEDCBA98_76543210;

        #1;


        check_outputs(64'hFEDCBA98_BA987654);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        addr = 3'b001;
        datamode = 2'b00;
        data_in = 64'h11223344_55667788;

        #1;


        check_outputs(64'h11223344_00000077);
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
