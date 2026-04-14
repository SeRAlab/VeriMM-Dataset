`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [127:0] key_in;
    reg mode_select;
    wire [63:0] data_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .key_in(key_in),
        .mode_select(mode_select),
        .data_out(data_out),
        .status(status)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Encryption (Mode 0)", test_num);

            data_in = 64'hA5A5A5A5A5A5A5A5;
            key_in = 128'h0123456789ABCDEF0123456789ABCDEF;
            mode_select = 1'b0;



            #1;




            check_outputs(64'hA486E1C22C6E4A4A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Decryption (Mode 1)", test_num);

            data_in = 64'hFFFFFFFFFFFFFFFF;
            key_in = 128'hFEDCBA98765432100000000000000000;
            mode_select = 1'b1;


            #1;



            check_outputs(64'h0123456789ABCDEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Encryption with All Zeros", test_num);
            data_in = 64'h0;
            key_in = 128'h0;
            mode_select = 1'b0;


            #1;



            check_outputs(64'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Decryption with All Ones", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            mode_select = 1'b1;


            #1;



            check_outputs(64'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data Toggle Pattern", test_num);
            data_in = 64'h5555555555555555;
            key_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            mode_select = 1'b0;


            #1;



            check_outputs(64'hFFFFFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key Sensitivity Check", test_num);
            data_in = 64'h0000000000000000;

            key_in = 128'h11111111111111112222222222222222;


            mode_select = 1'b0;
            #1;
            if (data_out === 64'h2222222222222222) begin
                $display("  Mode 0 correct.");
            end


            mode_select = 1'b1;
            #1;

            check_outputs(64'h1111111111111111, 1'b1);
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
        input [63:0] expected_data_out;
        input expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%b",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%b",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%b",
                         data_out, status);
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
