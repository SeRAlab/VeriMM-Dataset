`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [1:0] datamode;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .datamode(datamode),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            datamode = 2'b00;
            data_in = 64'hFEDCBA9876543210;
            #10;
            $display("Test %0d: Byte Alignment Mode (datamode=00)", test_num);

            #1;


            check_outputs(64'h1010101010101010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            datamode = 2'b01;
            data_in = 64'hFEDCBA9876543210;
            #10;
            $display("Test %0d: Half-word Alignment Mode (datamode=01)", test_num);

            #1;


            check_outputs(64'h3210321032103210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            datamode = 2'b10;
            data_in = 64'hFEDCBA9876543210;
            #10;
            $display("Test %0d: Word Alignment Mode (datamode=10)", test_num);

            #1;


            check_outputs(64'h7654321076543210);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            datamode = 2'b11;
            data_in = 64'hFEDCBA9876543210;
            #10;
            $display("Test %0d: Double-word Alignment Mode (datamode=11)", test_num);

            #1;


            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            datamode = 2'b00;
            data_in = 64'hFFFFFFFFFFFFFFAA;
            #10;
            $display("Test %0d: Byte Mode with AA", test_num);
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            datamode = 2'b01;
            data_in = 64'h0000000000005555;
            #10;
            $display("Test %0d: Half-word Mode with 5555", test_num);
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            datamode = 2'b10;
            data_in = 64'hFFFFFFFF12345678;
            #10;
            $display("Test %0d: Word Mode with 12345678", test_num);
            #1;

            check_outputs(64'h1234567812345678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            datamode = 2'b11;
            data_in = 64'hAAAAAAAAAAAAAAAA;
            #10;
            $display("Test %0d: Double-word Mode with AA...AA", test_num);
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
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
